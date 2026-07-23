<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Models\StockMovement;
use App\Models\StockOpname;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class StockOpnameController extends Controller
{
    // GET /api/v1/stock/opnames
    public function index(Request $request): JsonResponse
    {
        $query = StockOpname::with(['createdBy', 'approvedBy']);

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->filled('from')) {
            $query->whereDate('opname_date', '>=', $request->from);
        }

        if ($request->filled('to')) {
            $query->whereDate('opname_date', '<=', $request->to);
        }

        $opnames = $query->latest('opname_date')->paginate($request->get('per_page', 15));

        return response()->json(['status' => 'success', 'data' => $opnames]);
    }

    // POST /api/v1/stock/opnames — buat draft opname
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'opname_date' => 'required|date',
            'branch_id'   => 'nullable|exists:branches,id',
            'notes'       => 'nullable|string',
            'products'    => 'required|array|min:1',
            'products.*.product_id'    => 'required|exists:products,id',
            'products.*.actual_stock'  => 'required|integer|min:0',
            'products.*.notes'         => 'nullable|string',
        ]);

        return DB::transaction(function () use ($validated) {
            $opname = StockOpname::create([
                'created_by'    => auth()->id(),
                'branch_id'     => $validated['branch_id'] ?? null,
                'opname_number' => StockOpname::generateNumber(),
                'opname_date'   => $validated['opname_date'],
                'status'        => 'draft',
                'notes'         => $validated['notes'] ?? null,
            ]);

            // Simpan detail per produk
            $details = [];
            foreach ($validated['products'] as $item) {
                $product      = Product::find($item['product_id']);
                $systemStock  = $product->stock;
                $actualStock  = $item['actual_stock'];
                $difference   = $actualStock - $systemStock;

                $details[] = [
                    'stock_opname_id' => $opname->id,
                    'product_id'      => $item['product_id'],
                    'system_stock'    => $systemStock,
                    'actual_stock'    => $actualStock,
                    'difference'      => $difference,
                    'notes'           => $item['notes'] ?? null,
                    'created_at'      => now(),
                    'updated_at'      => now(),
                ];
            }

            $opname->details()->insert($details);

            return response()->json([
                'status'  => 'success',
                'message' => "Draft opname {$opname->opname_number} berhasil dibuat",
                'data'    => $opname->load(['details.product', 'createdBy']),
            ], 201);
        });
    }

    // GET /api/v1/stock/opnames/{id}
    public function show(StockOpname $stockOpname): JsonResponse
    {
        $stockOpname->load(['createdBy', 'approvedBy', 'details.product.category']);

        return response()->json(['status' => 'success', 'data' => $stockOpname]);
    }

    // PUT /api/v1/stock/opnames/{id} — edit detail (draft only)
    public function update(Request $request, StockOpname $stockOpname): JsonResponse
    {
        if ($stockOpname->status !== 'draft') {
            return response()->json([
                'status'  => 'error',
                'message' => 'Hanya opname draft yang bisa diedit',
            ], 422);
        }

        $validated = $request->validate([
            'notes'       => 'nullable|string',
            'products'    => 'sometimes|array|min:1',
            'products.*.product_id'   => 'required|exists:products,id',
            'products.*.actual_stock' => 'required|integer|min:0',
            'products.*.notes'        => 'nullable|string',
        ]);

        if (isset($validated['notes'])) {
            $stockOpname->update(['notes' => $validated['notes']]);
        }

        if (isset($validated['products'])) {
            $stockOpname->details()->delete();

            $details = [];
            foreach ($validated['products'] as $item) {
                $product = Product::find($item['product_id']);
                $details[] = [
                    'stock_opname_id' => $stockOpname->id,
                    'product_id'      => $item['product_id'],
                    'system_stock'    => $product->stock,
                    'actual_stock'    => $item['actual_stock'],
                    'difference'      => $item['actual_stock'] - $product->stock,
                    'notes'           => $item['notes'] ?? null,
                    'created_at'      => now(),
                    'updated_at'      => now(),
                ];
            }

            $stockOpname->details()->insert($details);
        }

        return response()->json([
            'status'  => 'success',
            'message' => 'Draft opname berhasil diupdate',
            'data'    => $stockOpname->load(['details.product', 'createdBy']),
        ]);
    }

    // POST /api/v1/stock/opnames/{id}/submit — submit untuk approve
    public function submit(StockOpname $stockOpname): JsonResponse
    {
        if ($stockOpname->status !== 'draft') {
            return response()->json([
                'status'  => 'error',
                'message' => 'Opname sudah ' . $stockOpname->status,
            ], 422);
        }

        $stockOpname->update([
            'status'       => 'submitted',
            'submitted_at' => now(),
        ]);

        return response()->json([
            'status'  => 'success',
            'message' => "Opname {$stockOpname->opname_number} berhasil disubmit",
            'data'    => $stockOpname,
        ]);
    }

    // POST /api/v1/stock/opnames/{id}/finish — approve + terapkan penyesuaian stok
    public function finish(Request $request, StockOpname $stockOpname): JsonResponse
    {
        if ($stockOpname->status !== 'submitted') {
            return response()->json([
                'status'  => 'error',
                'message' => 'Hanya opname submitted yang bisa di-finish',
            ], 422);
        }

        return DB::transaction(function () use ($stockOpname) {
            $stockOpname->load('details.product');

            // Terapkan penyesuaian stok per produk
            foreach ($stockOpname->details as $detail) {
                $product    = $detail->product;
                $oldStock   = $product->stock;
                $newStock   = $detail->actual_stock;
                $diff       = $newStock - $oldStock;

                if ($diff !== 0) {
                    $product->update(['stock' => $newStock]);

                    // Catat stock movement opname
                    StockMovement::create([
                        'product_id'   => $product->id,
                        'user_id'      => auth()->id(),
                        'type'         => $diff > 0 ? 'in' : 'out',
                        'reason'       => 'opname',
                        'quantity'     => abs($diff),
                        'stock_before' => $oldStock,
                        'stock_after'  => $newStock,
                        'notes'        => "Penyesuaian stok opname {$stockOpname->opname_number}",
                    ]);

                    // Trigger alert jika stok tipis
                    if ($product->stock <= $product->min_stock) {
                        broadcast(new \App\Events\LowStockAlert($product));
                    }
                }
            }

            $stockOpname->update([
                'status'      => 'approved',
                'approved_by' => auth()->id(),
                'approved_at' => now(),
            ]);

            return response()->json([
                'status'  => 'success',
                'message' => "Opname {$stockOpname->opname_number} selesai. Stok telah disesuaikan.",
                'data'    => $stockOpname->load(['details.product', 'approvedBy']),
            ]);
        });
    }
}
