<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Models\StockMovement;
use App\Models\Transaction;
use App\Models\TransactionItem;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class TransactionController extends Controller
{
    // GET /api/v1/transactions
    public function index(Request $request): JsonResponse
    {
        $query = Transaction::with(['customer', 'cashier', 'doctor', 'items', 'payments.paymentMethod']);

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->filled('from')) {
            $query->whereDate('created_at', '>=', $request->from);
        }

        if ($request->filled('to')) {
            $query->whereDate('created_at', '<=', $request->to);
        }

        if ($request->filled('customer_id')) {
            $query->where('customer_id', $request->customer_id);
        }

        if ($request->filled('cashier_id')) {
            $query->where('cashier_id', $request->cashier_id);
        }

        $transactions = $query->latest()->paginate($request->get('per_page', 15));

        return response()->json(['status' => 'success', 'data' => $transactions]);
    }

    // POST /api/v1/transactions — buat transaksi draft
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'customer_id'      => 'nullable|exists:customers,id',
            'doctor_id'        => 'nullable|exists:users,id',
            'queue_id'         => 'nullable|exists:queues,id',
            'branch_id'        => 'nullable|exists:branches,id',
            'discount_percent' => 'nullable|numeric|min:0|max:100',
            'discount_amount'  => 'nullable|numeric|min:0',
            'notes'            => 'nullable|string',
            'items'            => 'required|array|min:1',
            'items.*.type'     => 'required|in:product,treatment',
            'items.*.id'       => 'required|integer',
            'items.*.quantity' => 'required|integer|min:1',
            'items.*.discount_amount' => 'nullable|numeric|min:0',
        ]);

        return DB::transaction(function () use ($validated) {
            $subtotal         = 0;
            $itemsData        = [];
            $discountPercent  = $validated['discount_percent'] ?? 0;
            $discountAmount   = $validated['discount_amount'] ?? 0;

            foreach ($validated['items'] as $item) {
                if ($item['type'] === 'product') {
                    $model = Product::findOrFail($item['id']);
                    $price = $model->selling_price;
                    $itemableType = Product::class;
                } else {
                    $model = \App\Models\Treatment::findOrFail($item['id']);
                    $price = $model->price;
                    $itemableType = \App\Models\Treatment::class;
                }

                $itemDiscount = $item['discount_amount'] ?? 0;
                $itemSubtotal = ($price * $item['quantity']) - $itemDiscount;
                $subtotal    += $itemSubtotal;

                $itemsData[] = [
                    'itemable_type'   => $itemableType,
                    'itemable_id'     => $model->id,
                    'name'            => $model->name,
                    'price'           => $price,
                    'quantity'        => $item['quantity'],
                    'discount_amount' => $itemDiscount,
                    'subtotal'        => $itemSubtotal,
                ];
            }

            // Hitung total
            if ($discountPercent > 0) {
                $discountAmount = $subtotal * ($discountPercent / 100);
            }
            $total = max(0, $subtotal - $discountAmount);

            $transaction = Transaction::create([
                'transaction_number' => Transaction::generateNumber(),
                'customer_id'        => $validated['customer_id'] ?? null,
                'cashier_id'         => auth()->id(),
                'doctor_id'          => $validated['doctor_id'] ?? null,
                'queue_id'           => $validated['queue_id'] ?? null,
                'branch_id'          => $validated['branch_id'] ?? null,
                'subtotal'           => $subtotal,
                'discount_percent'   => $discountPercent,
                'discount_amount'    => $discountAmount,
                'total'              => $total,
                'status'             => 'draft',
            ]);

            // Insert items
            $transaction->items()->createMany($itemsData);

            return response()->json([
                'status'  => 'success',
                'message' => "Draft transaksi {$transaction->transaction_number} berhasil dibuat",
                'data'    => $transaction->load(['items', 'customer', 'cashier']),
            ], 201);
        });
    }

    // GET /api/v1/transactions/{id}
    public function show(Transaction $transaction): JsonResponse
    {
        $transaction->load(['customer', 'cashier', 'doctor', 'queue', 'items.itemable', 'payments.paymentMethod']);

        return response()->json(['status' => 'success', 'data' => $transaction]);
    }

    // PUT /api/v1/transactions/{id} — update draft
    public function update(Request $request, Transaction $transaction): JsonResponse
    {
        if ($transaction->status !== 'draft') {
            return response()->json([
                'status'  => 'error',
                'message' => 'Hanya transaksi dengan status draft yang bisa diedit',
            ], 422);
        }

        $validated = $request->validate([
            'customer_id'      => 'nullable|exists:customers,id',
            'doctor_id'        => 'nullable|exists:users,id',
            'discount_percent' => 'nullable|numeric|min:0|max:100',
            'discount_amount'  => 'nullable|numeric|min:0',
            'notes'            => 'nullable|string',
        ]);

        $transaction->update($validated);

        return response()->json([
            'status'  => 'success',
            'message' => 'Draft transaksi berhasil diupdate',
            'data'    => $transaction->load(['items', 'customer']),
        ]);
    }

    // PUT /api/v1/transactions/{id}/pay — proses pembayaran
    public function pay(Request $request, Transaction $transaction): JsonResponse
    {
        if (in_array($transaction->status, ['paid', 'cancelled'])) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Transaksi sudah ' . $transaction->status,
            ], 422);
        }

        $validated = $request->validate([
            'payments'                       => 'required|array|min:1',
            'payments.*.payment_method_id'   => 'required|exists:payment_methods,id',
            'payments.*.amount'              => 'required|numeric|min:0',
            'payments.*.reference_number'    => 'nullable|string|max:100',
            'payments.*.notes'               => 'nullable|string',
        ]);

        return DB::transaction(function () use ($validated, $transaction) {
            $totalPaid = collect($validated['payments'])->sum('amount');

            if ($totalPaid < $transaction->total) {
                return response()->json([
                    'status'  => 'error',
                    'message' => sprintf(
                        'Total pembayaran (Rp %s) kurang dari total transaksi (Rp %s)',
                        number_format($totalPaid, 0, ',', '.'),
                        number_format($transaction->total, 0, ',', '.'),
                    ),
                ], 422);
            }

            // Hapus payment lama jika ada (re-pay)
            $transaction->payments()->delete();

            // Insert payments baru
            foreach ($validated['payments'] as $pay) {
                $transaction->payments()->create($pay);
            }

            $change = $totalPaid - $transaction->total;

            $transaction->update([
                'paid_amount'  => $totalPaid,
                'change_amount' => $change,
                'status'       => 'paid',
                'payment_type' => count($validated['payments']) > 1 ? 'split' : 'single',
                'paid_at'      => now(),
            ]);

            // Kurangi stok produk
            foreach ($transaction->items as $item) {
                if ($item->itemable_type === Product::class) {
                    $product = Product::find($item->itemable_id);
                    if ($product) {
                        $before = $product->stock;
                        $after  = max(0, $before - $item->quantity);

                        $product->decrement('stock', $item->quantity);

                        StockMovement::create([
                            'product_id'     => $product->id,
                            'user_id'        => auth()->id(),
                            'type'           => 'out',
                            'reason'         => 'sale',
                            'quantity'       => $item->quantity,
                            'stock_before'   => $before,
                            'stock_after'    => $after,
                            'notes'          => "Terjual - {$transaction->transaction_number}",
                            'reference_type' => Transaction::class,
                            'reference_id'   => $transaction->id,
                        ]);

                        // Trigger alert jika stok tipis
                        if ($product->refresh()->stock <= $product->min_stock) {
                            broadcast(new \App\Events\LowStockAlert($product));
                        }
                    }
                }
            }

            return response()->json([
                'status'  => 'success',
                'message' => "Transaksi {$transaction->transaction_number} berhasil dibayar. Kembalian: Rp " . number_format($change, 0, ',', '.'),
                'data'    => $transaction->load(['items.itemable', 'payments.paymentMethod', 'customer', 'cashier']),
            ]);
        });
    }

    // GET /api/v1/transactions/{id}/receipt — detail struk
    public function receipt(Transaction $transaction): JsonResponse
    {
        if ($transaction->status !== 'paid') {
            return response()->json([
                'status'  => 'error',
                'message' => 'Struk hanya tersedia untuk transaksi yang sudah dibayar',
            ], 422);
        }

        $transaction->load([
            'customer', 'cashier', 'doctor',
            'items.itemable', 'payments.paymentMethod',
        ]);

        $companySetting = \App\Models\CompanySetting::getInstance();

        return response()->json([
            'status' => 'success',
            'data'   => [
                'transaction'     => $transaction,
                'company_setting' => $companySetting,
            ],
        ]);
    }

    // DELETE /api/v1/transactions/{id} — batalkan transaksi
    public function destroy(Transaction $transaction): JsonResponse
    {
        if ($transaction->status === 'paid') {
            return response()->json([
                'status'  => 'error',
                'message' => 'Transaksi yang sudah dibayar tidak bisa dibatalkan',
            ], 422);
        }

        $transaction->update(['status' => 'cancelled']);
        $transaction->delete();

        return response()->json(['status' => 'success', 'message' => 'Transaksi berhasil dibatalkan']);
    }
}
