<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MedicalRecord;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MedicalRecordController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = MedicalRecord::with(['customer', 'doctor', 'photos']);

        if ($request->filled('customer_id')) {
            $query->where('customer_id', $request->customer_id);
        }

        if ($request->filled('doctor_id')) {
            $query->where('doctor_id', $request->doctor_id);
        }

        if ($request->filled('from')) {
            $query->whereDate('visit_date', '>=', $request->from);
        }

        if ($request->filled('to')) {
            $query->whereDate('visit_date', '<=', $request->to);
        }

        if ($request->filled('search')) {
            $search = $request->search;
            $query->whereHas('customer', fn($q) => $q->where('name', 'like', "%{$search}%"));
        }

        $records = $query->latest('visit_date')->paginate($request->get('per_page', 15));

        return response()->json(['status' => 'success', 'data' => $records]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'customer_id'   => 'required|exists:customers,id',
            'visit_date'    => 'required|date',
            'complaint'     => 'nullable|string',
            'diagnosis'     => 'nullable|string',
            'action'        => 'nullable|string',
            'recommendation' => 'nullable|string',
            'notes'         => 'nullable|string',
            'allergy_notes' => 'nullable|string',
            'blood_pressure' => 'nullable|string|max:20',
            'weight'        => 'nullable|numeric|min:0',
            'height'        => 'nullable|numeric|min:0',
        ]);

        $validated['doctor_id'] = auth()->id();

        $record = MedicalRecord::create($validated);

        return response()->json([
            'status'  => 'success',
            'message' => 'Rekam medis berhasil ditambahkan',
            'data'    => $record->load(['customer', 'doctor', 'photos']),
        ], 201);
    }

    public function show(MedicalRecord $medicalRecord): JsonResponse
    {
        $medicalRecord->load(['customer', 'doctor', 'photos']);

        return response()->json(['status' => 'success', 'data' => $medicalRecord]);
    }

    public function update(Request $request, MedicalRecord $medicalRecord): JsonResponse
    {
        $validated = $request->validate([
            'visit_date'    => 'sometimes|date',
            'complaint'     => 'nullable|string',
            'diagnosis'     => 'nullable|string',
            'action'        => 'nullable|string',
            'recommendation' => 'nullable|string',
            'notes'         => 'nullable|string',
            'allergy_notes' => 'nullable|string',
            'blood_pressure' => 'nullable|string|max:20',
            'weight'        => 'nullable|numeric|min:0',
            'height'        => 'nullable|numeric|min:0',
        ]);

        $medicalRecord->update($validated);

        return response()->json([
            'status'  => 'success',
            'message' => 'Rekam medis berhasil diupdate',
            'data'    => $medicalRecord->load(['customer', 'doctor', 'photos']),
        ]);
    }

    public function destroy(MedicalRecord $medicalRecord): JsonResponse
    {
        $medicalRecord->delete();

        return response()->json(['status' => 'success', 'message' => 'Rekam medis berhasil dihapus']);
    }
}
