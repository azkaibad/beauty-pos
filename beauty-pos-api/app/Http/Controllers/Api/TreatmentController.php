<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Treatment;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class TreatmentController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Treatment::with('category');

        if ($request->filled('search')) {
            $query->where('name', 'like', "%{$request->search}%");
        }

        if ($request->filled('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        if ($request->filled('is_active')) {
            $query->where('is_active', $request->boolean('is_active'));
        }

        $treatments = $query->latest()->paginate($request->get('per_page', 15));

        return response()->json(['status' => 'success', 'data' => $treatments]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'category_id'      => 'nullable|exists:categories,id',
            'name'             => 'required|string|max:255',
            'description'      => 'nullable|string',
            'duration_minutes' => 'nullable|integer|min:1',
            'price'            => 'required|numeric|min:0',
            'photo'            => 'nullable|image|max:2048',
        ]);

        if ($request->hasFile('photo')) {
            $validated['photo'] = $request->file('photo')->store('treatments', 'public');
        }

        $treatment = Treatment::create($validated);

        return response()->json([
            'status'  => 'success',
            'message' => 'Treatment berhasil ditambahkan',
            'data'    => $treatment->load('category'),
        ], 201);
    }

    public function show(Treatment $treatment): JsonResponse
    {
        return response()->json(['status' => 'success', 'data' => $treatment->load('category')]);
    }

    public function update(Request $request, Treatment $treatment): JsonResponse
    {
        $validated = $request->validate([
            'category_id'      => 'nullable|exists:categories,id',
            'name'             => 'sometimes|string|max:255',
            'description'      => 'nullable|string',
            'duration_minutes' => 'nullable|integer|min:1',
            'price'            => 'sometimes|numeric|min:0',
            'is_active'        => 'nullable|boolean',
            'photo'            => 'nullable|image|max:2048',
        ]);

        if ($request->hasFile('photo')) {
            $validated['photo'] = $request->file('photo')->store('treatments', 'public');
        }

        $treatment->update($validated);

        return response()->json([
            'status'  => 'success',
            'message' => 'Treatment berhasil diupdate',
            'data'    => $treatment->load('category'),
        ]);
    }

    public function destroy(Treatment $treatment): JsonResponse
    {
        $treatment->delete();

        return response()->json(['status' => 'success', 'message' => 'Treatment berhasil dihapus']);
    }
}
