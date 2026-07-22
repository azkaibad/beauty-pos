<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\FollowUp;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class FollowUpController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = FollowUp::with(['customer', 'assignedTo', 'medicalRecord']);

        if ($request->filled('status'))   $query->where('status', $request->status);
        if ($request->filled('priority')) $query->where('priority', $request->priority);
        if ($request->filled('from'))     $query->whereDate('due_date', '>=', $request->from);
        if ($request->filled('to'))       $query->whereDate('due_date', '<=', $request->to);
        if ($request->filled('assigned_to')) $query->where('assigned_to', $request->assigned_to);

        $followUps = $query->orderBy('due_date')->paginate($request->get('per_page', 15));

        return response()->json(['status' => 'success', 'data' => $followUps]);
    }

    public function today(): JsonResponse
    {
        $followUps = FollowUp::with(['customer', 'assignedTo'])
            ->where('status', 'pending')
            ->whereDate('due_date', today())
            ->orderBy('priority', 'desc')
            ->get();

        return response()->json(['status' => 'success', 'data' => $followUps]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'customer_id'       => 'required|exists:customers,id',
            'assigned_to'       => 'nullable|exists:users,id',
            'medical_record_id' => 'nullable|exists:medical_records,id',
            'title'             => 'required|string|max:255',
            'notes'             => 'nullable|string',
            'due_date'          => 'required|date|after_or_equal:today',
            'priority'          => 'nullable|in:low,medium,high',
        ]);

        $followUp = FollowUp::create($validated);

        return response()->json([
            'status'  => 'success',
            'message' => 'Follow-up berhasil ditambahkan',
            'data'    => $followUp->load(['customer', 'assignedTo']),
        ], 201);
    }

    public function show(FollowUp $followUp): JsonResponse
    {
        return response()->json(['status' => 'success', 'data' => $followUp->load(['customer', 'assignedTo', 'medicalRecord'])]);
    }

    public function update(Request $request, FollowUp $followUp): JsonResponse
    {
        $validated = $request->validate([
            'title'       => 'sometimes|string|max:255',
            'notes'       => 'nullable|string',
            'due_date'    => 'sometimes|date',
            'priority'    => 'sometimes|in:low,medium,high',
            'assigned_to' => 'nullable|exists:users,id',
            'status'      => 'sometimes|in:pending,contacted,completed,cancelled',
        ]);

        $followUp->update($validated);

        return response()->json(['status' => 'success', 'message' => 'Follow-up berhasil diupdate', 'data' => $followUp]);
    }

    public function contact(Request $request, FollowUp $followUp): JsonResponse
    {
        $request->validate(['result' => 'nullable|string']);

        $followUp->update([
            'status'       => 'contacted',
            'result'       => $request->result,
            'contacted_at' => now(),
        ]);

        return response()->json([
            'status'  => 'success',
            'message' => 'Follow-up ditandai sudah dihubungi',
            'data'    => $followUp->load('customer'),
        ]);
    }

    public function destroy(FollowUp $followUp): JsonResponse
    {
        $followUp->delete();

        return response()->json(['status' => 'success', 'message' => 'Follow-up berhasil dihapus']);
    }
}
