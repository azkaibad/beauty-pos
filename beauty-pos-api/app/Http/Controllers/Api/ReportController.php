<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Closing;
use App\Models\ExpenseRequest;
use App\Models\MedicalRecord;
use App\Models\Payment;
use App\Models\Product;
use App\Models\StockMovement;
use App\Models\Transaction;
use App\Models\TransactionItem;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ReportController extends Controller
{
    // GET /api/v1/reports/sales/daily?date=YYYY-MM-DD
    public function salesDaily(Request $request): JsonResponse
    {
        $date = $request->get('date', today()->toDateString());

        $transactions = Transaction::where('status', 'paid')
            ->whereDate('paid_at', $date)
            ->with(['items', 'payments.paymentMethod', 'cashier'])
            ->get();

        $summary = [
            'date'          => $date,
            'total'         => $transactions->sum('total'),
            'count'         => $transactions->count(),
            'subtotal'      => $transactions->sum('subtotal'),
            'total_discount'=> $transactions->sum('discount_amount'),
        ];

        return response()->json([
            'status'       => 'success',
            'summary'      => $summary,
            'transactions' => $transactions,
        ]);
    }

    // GET /api/v1/reports/sales/monthly?month=YYYY-MM
    public function salesMonthly(Request $request): JsonResponse
    {
        $month = $request->get('month', now()->format('Y-m'));
        [$year, $mon] = explode('-', $month);

        $daily = Transaction::where('status', 'paid')
            ->whereYear('paid_at', $year)
            ->whereMonth('paid_at', $mon)
            ->selectRaw('DATE(paid_at) as date, SUM(total) as total, COUNT(*) as count')
            ->groupBy('date')
            ->orderBy('date')
            ->get();

        $totalRevenue = $daily->sum('total');
        $totalCount   = $daily->sum('count');

        return response()->json([
            'status'  => 'success',
            'month'   => $month,
            'summary' => ['total' => $totalRevenue, 'count' => $totalCount],
            'data'    => $daily,
        ]);
    }

    // GET /api/v1/reports/sales/by-payment?from=&to=
    public function salesByPayment(Request $request): JsonResponse
    {
        $from = $request->get('from', today()->toDateString());
        $to   = $request->get('to',   today()->toDateString());

        $data = Payment::join('transactions', 'payments.transaction_id', '=', 'transactions.id')
            ->join('payment_methods', 'payments.payment_method_id', '=', 'payment_methods.id')
            ->where('transactions.status', 'paid')
            ->whereBetween(DB::raw('DATE(transactions.paid_at)'), [$from, $to])
            ->selectRaw('payment_methods.name, payment_methods.code, SUM(payments.amount) as total, COUNT(DISTINCT payments.transaction_id) as count')
            ->groupBy('payment_methods.id', 'payment_methods.name', 'payment_methods.code')
            ->get();

        return response()->json(['status' => 'success', 'from' => $from, 'to' => $to, 'data' => $data]);
    }

    // GET /api/v1/reports/stock/movements?from=&to=
    public function stockMovements(Request $request): JsonResponse
    {
        $query = StockMovement::with(['product', 'user']);

        if ($request->filled('from')) $query->whereDate('created_at', '>=', $request->from);
        if ($request->filled('to'))   $query->whereDate('created_at', '<=', $request->to);
        if ($request->filled('type')) $query->where('type', $request->type);

        $data = $query->latest()->paginate($request->get('per_page', 20));

        return response()->json(['status' => 'success', 'data' => $data]);
    }

    // GET /api/v1/reports/stock/current
    public function stockCurrent(): JsonResponse
    {
        $products = Product::with('category')
            ->where('is_active', true)
            ->orderBy('name')
            ->get()
            ->map(fn($p) => [
                ...$p->toArray(),
                'is_low_stock' => $p->stock <= $p->min_stock,
            ]);

        return response()->json(['status' => 'success', 'data' => $products]);
    }

    // GET /api/v1/reports/medical-records?from=&to=
    public function medicalRecords(Request $request): JsonResponse
    {
        $query = MedicalRecord::with(['customer', 'doctor']);

        if ($request->filled('from')) $query->whereDate('visit_date', '>=', $request->from);
        if ($request->filled('to'))   $query->whereDate('visit_date', '<=', $request->to);

        $records = $query->latest('visit_date')->paginate($request->get('per_page', 15));
        $total   = $query->count();

        return response()->json(['status' => 'success', 'total' => $total, 'data' => $records]);
    }

    // GET /api/v1/reports/treatments?from=&to=
    public function treatments(Request $request): JsonResponse
    {
        $from = $request->get('from', today()->startOfMonth()->toDateString());
        $to   = $request->get('to',   today()->toDateString());

        $data = TransactionItem::join('transactions', 'transaction_items.transaction_id', '=', 'transactions.id')
            ->where('transactions.status', 'paid')
            ->where('transaction_items.itemable_type', \App\Models\Treatment::class)
            ->whereBetween(DB::raw('DATE(transactions.paid_at)'), [$from, $to])
            ->selectRaw('transaction_items.name, SUM(transaction_items.quantity) as count, SUM(transaction_items.subtotal) as total')
            ->groupBy('transaction_items.name')
            ->orderByDesc('count')
            ->get();

        return response()->json(['status' => 'success', 'from' => $from, 'to' => $to, 'data' => $data]);
    }

    // GET /api/v1/reports/practitioners?from=&to=
    public function practitioners(Request $request): JsonResponse
    {
        $from = $request->get('from', today()->startOfMonth()->toDateString());
        $to   = $request->get('to',   today()->toDateString());

        $data = MedicalRecord::with('doctor')
            ->whereHas('doctor')
            ->whereDate('visit_date', '>=', $from)
            ->whereDate('visit_date', '<=', $to)
            ->selectRaw('doctor_id, COUNT(*) as visit_count')
            ->groupBy('doctor_id')
            ->with('doctor:id,name')
            ->get();

        return response()->json(['status' => 'success', 'from' => $from, 'to' => $to, 'data' => $data]);
    }

    // GET /api/v1/reports/expenses?from=&to=
    public function expenses(Request $request): JsonResponse
    {
        $query = ExpenseRequest::with(['requestedBy', 'approvedBy']);

        if ($request->filled('status'))   $query->where('status', $request->status);
        if ($request->filled('from'))     $query->whereDate('created_at', '>=', $request->from);
        if ($request->filled('to'))       $query->whereDate('created_at', '<=', $request->to);

        $expenses  = $query->latest()->paginate($request->get('per_page', 20));
        $totalApproved = ExpenseRequest::where('status', 'approved')
            ->when($request->filled('from'), fn($q) => $q->whereDate('created_at', '>=', $request->from))
            ->when($request->filled('to'),   fn($q) => $q->whereDate('created_at', '<=', $request->to))
            ->sum('amount');

        return response()->json([
            'status'        => 'success',
            'total_approved'=> $totalApproved,
            'data'          => $expenses,
        ]);
    }

    // GET /api/v1/reports/balance?date=YYYY-MM-DD
    public function balance(Request $request): JsonResponse
    {
        $date = $request->get('date', today()->toDateString());

        $income   = Transaction::where('status', 'paid')->whereDate('paid_at', $date)->sum('total');
        $expenses = ExpenseRequest::where('status', 'approved')->whereDate('approved_at', $date)->sum('amount');
        $balance  = $income - $expenses;

        return response()->json([
            'status' => 'success',
            'data'   => ['date' => $date, 'income' => $income, 'expenses' => $expenses, 'balance' => $balance],
        ]);
    }

    // GET /api/v1/reports/revenue?month=YYYY-MM
    public function revenue(Request $request): JsonResponse
    {
        $month = $request->get('month', now()->format('Y-m'));
        [$year, $mon] = explode('-', $month);

        $revenue  = Transaction::where('status', 'paid')
            ->whereYear('paid_at', $year)->whereMonth('paid_at', $mon)->sum('total');
        $expenses = ExpenseRequest::where('status', 'approved')
            ->whereYear('approved_at', $year)->whereMonth('approved_at', $mon)->sum('amount');

        return response()->json([
            'status' => 'success',
            'month'  => $month,
            'data'   => ['revenue' => $revenue, 'expenses' => $expenses, 'net' => $revenue - $expenses],
        ]);
    }

    // GET /api/v1/reports/closings?from=&to=
    public function closings(Request $request): JsonResponse
    {
        $query = Closing::with(['cashier', 'approvedBy', 'details.paymentMethod']);

        if ($request->filled('from')) $query->whereDate('closing_date', '>=', $request->from);
        if ($request->filled('to'))   $query->whereDate('closing_date', '<=', $request->to);

        $closings = $query->latest('closing_date')->get();

        return response()->json(['status' => 'success', 'data' => $closings]);
    }

    // GET /api/v1/reports/export/{type}?from=&to=
    public function export(Request $request, string $type)
    {
        $from = $request->get('from', today()->startOfMonth()->toDateString());
        $to   = $request->get('to',   today()->toDateString());

        return match ($type) {
            'sales'    => \Maatwebsite\Excel\Facades\Excel::download(new \App\Exports\SalesExport($from, $to), "sales_report_{$from}_{$to}.xlsx"),
            'stock'    => \Maatwebsite\Excel\Facades\Excel::download(new \App\Exports\StockExport(), "stock_report.xlsx"),
            'expenses' => \Maatwebsite\Excel\Facades\Excel::download(new \App\Exports\ExpenseExport($from, $to), "expenses_report_{$from}_{$to}.xlsx"),
            default    => response()->json(['status' => 'error', 'message' => "Tipe export '{$type}' tidak didukung"], 400),
        };
    }
}
