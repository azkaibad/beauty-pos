<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Closing;
use App\Models\ClosingDetail;
use App\Models\PaymentMethod;
use App\Models\Transaction;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ClosingController extends Controller
{
    // GET /api/v1/closings
    public function index(Request $request): JsonResponse
    {
        $query = Closing::with(['cashier', 'approvedBy', 'details.paymentMethod']);

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->filled('shift')) {
            $query->where('shift', $request->shift);
        }

        if ($request->filled('from')) {
            $query->whereDate('closing_date', '>=', $request->from);
        }

        if ($request->filled('to')) {
            $query->whereDate('closing_date', '<=', $request->to);
        }

        $closings = $query->latest('closing_date')->paginate($request->get('per_page', 15));

        return response()->json(['status' => 'success', 'data' => $closings]);
    }

    // POST /api/v1/closings — buat closing shift
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'shift'         => 'required|in:morning,evening',
            'closing_date'  => 'required|date',
            'branch_id'     => 'nullable|exists:branches,id',
            'notes'         => 'nullable|string',
            'details'       => 'required|array|min:1',
            'details.*.payment_method_id' => 'required|exists:payment_methods,id',
            'details.*.actual_amount'     => 'required|numeric|min:0',
        ]);

        return DB::transaction(function () use ($validated) {
            // Hitung total dari sistem (transaksi paid di tanggal & shift)
            $systemTotal   = 0;
            $totalCount    = 0;
            $detailsSystem = [];
            $paymentMethods = PaymentMethod::where('is_active', true)->get();

            // Ambil transaksi paid pada tanggal closing
            $transactions = Transaction::where('status', 'paid')
                ->whereDate('paid_at', $validated['closing_date'])
                ->with('payments.paymentMethod')
                ->get();

            $totalCount  = $transactions->count();
            $systemTotal = $transactions->sum('total');

            // Rekap per metode bayar dari sistem
            $systemByMethod = [];
            foreach ($transactions as $trx) {
                foreach ($trx->payments as $pay) {
                    $methodId = $pay->payment_method_id;
                    $systemByMethod[$methodId] = ($systemByMethod[$methodId] ?? 0) + $pay->amount;
                }
            }

            // Hitung actual total dan selisih
            $actualTotal = 0;
            $detailsData = [];

            foreach ($validated['details'] as $detail) {
                $methodId     = $detail['payment_method_id'];
                $actualAmount = $detail['actual_amount'];
                $systemAmount = $systemByMethod[$methodId] ?? 0;
                $difference   = $actualAmount - $systemAmount;
                $actualTotal += $actualAmount;

                $detailsData[] = [
                    'payment_method_id' => $methodId,
                    'system_amount'     => $systemAmount,
                    'actual_amount'     => $actualAmount,
                    'difference'        => $difference,
                ];
            }

            $closing = Closing::create([
                'cashier_id'         => auth()->id(),
                'branch_id'          => $validated['branch_id'] ?? null,
                'shift'              => $validated['shift'],
                'closing_date'       => $validated['closing_date'],
                'total_transactions' => $systemTotal,
                'total_actual'       => $actualTotal,
                'difference'         => $actualTotal - $systemTotal,
                'total_count'        => $totalCount,
                'status'             => 'submitted',
                'notes'              => $validated['notes'] ?? null,
                'submitted_at'       => now(),
            ]);

            $closing->details()->createMany($detailsData);

            return response()->json([
                'status'  => 'success',
                'message' => 'Closing shift berhasil disubmit',
                'data'    => $closing->load(['details.paymentMethod', 'cashier']),
            ], 201);
        });
    }

    // GET /api/v1/closings/{id}
    public function show(Closing $closing): JsonResponse
    {
        $closing->load(['cashier', 'approvedBy', 'details.paymentMethod']);

        return response()->json(['status' => 'success', 'data' => $closing]);
    }

    // PUT /api/v1/closings/{id}/approve — approve closing (Manager/Owner)
    public function approve(Request $request, Closing $closing): JsonResponse
    {
        if ($closing->status !== 'submitted') {
            return response()->json([
                'status'  => 'error',
                'message' => 'Hanya closing dengan status submitted yang bisa diapprove',
            ], 422);
        }

        $closing->update([
            'status'      => 'approved',
            'approved_by' => auth()->id(),
            'approved_at' => now(),
        ]);

        return response()->json([
            'status'  => 'success',
            'message' => 'Closing berhasil diapprove',
            'data'    => $closing->load(['cashier', 'approvedBy', 'details.paymentMethod']),
        ]);
    }

    // GET /api/v1/closings/summary — ringkasan closing hari ini
    public function summary(Request $request): JsonResponse
    {
        $date = $request->get('date', today()->toDateString());

        $closings = Closing::with(['details.paymentMethod', 'cashier'])
            ->whereDate('closing_date', $date)
            ->get();

        $totalTransactions = Transaction::where('status', 'paid')
            ->whereDate('paid_at', $date)
            ->sum('total');

        $totalCount = Transaction::where('status', 'paid')
            ->whereDate('paid_at', $date)
            ->count();

        return response()->json([
            'status' => 'success',
            'data'   => [
                'date'              => $date,
                'total_transactions' => $totalTransactions,
                'total_count'       => $totalCount,
                'closings'          => $closings,
            ],
        ]);
    }

    // DELETE — tidak tersedia untuk closing
    public function destroy(Closing $closing): JsonResponse
    {
        return response()->json(['status' => 'error', 'message' => 'Closing tidak bisa dihapus'], 403);
    }
}
