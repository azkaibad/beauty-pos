<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Customer;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CustomerController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Customer::query();

        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('phone', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%");
            });
        }

        if ($request->filled('is_active')) {
            $query->where('is_active', $request->boolean('is_active'));
        }

        $customers = $query->latest()->paginate($request->get('per_page', 15));

        return response()->json([
            'status' => 'success',
            'data'   => $customers,
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name'       => 'required|string|max:255',
            'phone'      => 'required|string|max:20|unique:customers',
            'email'      => 'nullable|email|unique:customers',
            'birth_date' => 'nullable|date',
            'gender'     => 'nullable|in:male,female',
            'address'    => 'nullable|string',
            'allergy'    => 'nullable|string|max:255',
            'notes'      => 'nullable|string',
            'photo'      => 'nullable|image|max:2048',
        ]);

        if ($request->hasFile('photo')) {
            $validated['photo'] = $request->file('photo')->store('customers', 'public');
        }

        $customer = Customer::create($validated);

        return response()->json([
            'status'  => 'success',
            'message' => 'Customer berhasil ditambahkan',
            'data'    => $customer,
        ], 201);
    }

    public function show(Customer $customer): JsonResponse
    {
        $customer->load(['medicalRecords.doctor', 'latestMedicalRecord']);

        return response()->json([
            'status' => 'success',
            'data'   => $customer,
        ]);
    }

    public function update(Request $request, Customer $customer): JsonResponse
    {
        $validated = $request->validate([
            'name'       => 'sometimes|string|max:255',
            'phone'      => 'sometimes|string|max:20|unique:customers,phone,' . $customer->id,
            'email'      => 'nullable|email|unique:customers,email,' . $customer->id,
            'birth_date' => 'nullable|date',
            'gender'     => 'nullable|in:male,female',
            'address'    => 'nullable|string',
            'allergy'    => 'nullable|string|max:255',
            'notes'      => 'nullable|string',
            'is_active'  => 'nullable|boolean',
            'photo'      => 'nullable|image|max:2048',
        ]);

        if ($request->hasFile('photo')) {
            $validated['photo'] = $request->file('photo')->store('customers', 'public');
        }

        $customer->update($validated);

        return response()->json([
            'status'  => 'success',
            'message' => 'Customer berhasil diupdate',
            'data'    => $customer,
        ]);
    }

    public function destroy(Customer $customer): JsonResponse
    {
        $customer->delete();

        return response()->json([
            'status'  => 'success',
            'message' => 'Customer berhasil dihapus',
        ]);
    }
}
