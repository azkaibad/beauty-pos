<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ExpenseRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ExpenseController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = ExpenseRequest::with(['requestedBy', 'approvedBy']);

        if ($request->filled('status'))   $query->where('status', $request->status);
        if ($request->filled('category')) $query->where('category', $request->category);
        if ($request->filled('from'))     $query->whereDate('created_at', '>=', $request->from);
        if ($request->filled('to'))       $query->whereDate('created_at', '<=', $request->to);

        $expenses = $query->latest()->paginate($request->get('per_page', 15));

        return response()->json(['status' => 'success', 'data' => $expenses]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'title'       => 'required|string|max:255',
            'description' => 'nullable|string',
            'amount'      => 'required|numeric|min:0',
            'category'    => 'required|in:operational,purchase,maintenance,salary,other',
            'branch_id'   => 'nullable|exists:branches,id',
        ]);

        $expense = ExpenseRequest::create([
            ...$validated,
            'requested_by' => auth()->id(),
        ]);

        return response()->json([
            'status'  => 'success',
            'message' => 'Pengajuan pengeluaran berhasil dibuat',
            'data'    => $expense->load('requestedBy'),
        ], 201);
    }

    public function show(ExpenseRequest $expense): JsonResponse
    {
        return response()->json(['status' => 'success', 'data' => $expense->load(['requestedBy', 'approvedBy'])]);
    }

    public function update(Request $request, ExpenseRequest $expense): JsonResponse
    {
        if ($expense->status !== 'pending') {
            return response()->json(['status' => 'error', 'message' => 'Hanya pengajuan pending yang bisa diedit'], 422);
        }

        $validated = $request->validate([
            'title'       => 'sometimes|string|max:255',
            'description' => 'nullable|string',
            'amount'      => 'sometimes|numeric|min:0',
            'category'    => 'sometimes|in:operational,purchase,maintenance,salary,other',
        ]);

        $expense->update($validated);

        return response()->json(['status' => 'success', 'message' => 'Pengajuan berhasil diupdate', 'data' => $expense]);
    }

    public function destroy(ExpenseRequest $expense): JsonResponse
    {
        if ($expense->status !== 'pending') {
            return response()->json(['status' => 'error', 'message' => 'Hanya pengajuan pending yang bisa dihapus'], 422);
        }

        $expense->delete();

        return response()->json(['status' => 'success', 'message' => 'Pengajuan berhasil dihapus']);
    }

    public function approve(ExpenseRequest $expense): JsonResponse
    {
        if ($expense->status !== 'pending') {
            return response()->json(['status' => 'error', 'message' => 'Pengajuan sudah ' . $expense->status], 422);
        }

        $expense->update([
            'status'      => 'approved',
            'approved_by' => auth()->id(),
            'approved_at' => now(),
        ]);

        return response()->json(['status' => 'success', 'message' => 'Pengajuan diapprove', 'data' => $expense]);
    }

    public function reject(Request $request, ExpenseRequest $expense): JsonResponse
    {
        $request->validate(['reject_reason' => 'nullable|string']);

        if ($expense->status !== 'pending') {
            return response()->json(['status' => 'error', 'message' => 'Pengajuan sudah ' . $expense->status], 422);
        }

        $expense->update([
            'status'        => 'rejected',
            'approved_by'   => auth()->id(),
            'reject_reason' => $request->reject_reason,
            'approved_at'   => now(),
        ]);

        return response()->json(['status' => 'success', 'message' => 'Pengajuan ditolak', 'data' => $expense]);
    }

    public function uploadBukti(Request $request, ExpenseRequest $expense): JsonResponse
    {
        $request->validate(['bukti' => 'required|image|max:5120']);

        if ($expense->bukti) {
            Storage::disk('public')->delete($expense->bukti);
        }

        $path = $request->file('bukti')->store('expenses', 'public');
        $expense->update(['bukti' => $path]);

        return response()->json([
            'status'  => 'success',
            'message' => 'Bukti berhasil diupload',
            'data'    => ['bukti_url' => asset('storage/' . $path)],
        ]);
    }
}
