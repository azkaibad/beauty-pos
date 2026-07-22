<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PaymentMethod;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PaymentMethodController extends Controller
{
    public function index(): JsonResponse
    {
        $methods = PaymentMethod::orderBy('sort_order')->get();

        return response()->json(['status' => 'success', 'data' => $methods]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name'        => 'required|string|max:100',
            'code'        => 'required|string|max:20|unique:payment_methods',
            'description' => 'nullable|string',
            'sort_order'  => 'nullable|integer',
        ]);

        $method = PaymentMethod::create($validated);

        return response()->json([
            'status'  => 'success',
            'message' => 'Metode pembayaran berhasil ditambahkan',
            'data'    => $method,
        ], 201);
    }

    public function show(PaymentMethod $paymentMethod): JsonResponse
    {
        return response()->json(['status' => 'success', 'data' => $paymentMethod]);
    }

    public function update(Request $request, PaymentMethod $paymentMethod): JsonResponse
    {
        $validated = $request->validate([
            'name'        => 'sometimes|string|max:100',
            'description' => 'nullable|string',
            'is_active'   => 'nullable|boolean',
            'sort_order'  => 'nullable|integer',
        ]);

        $paymentMethod->update($validated);

        return response()->json([
            'status'  => 'success',
            'message' => 'Metode pembayaran berhasil diupdate',
            'data'    => $paymentMethod,
        ]);
    }

    public function destroy(PaymentMethod $paymentMethod): JsonResponse
    {
        $paymentMethod->delete();

        return response()->json(['status' => 'success', 'message' => 'Metode pembayaran berhasil dihapus']);
    }
}
