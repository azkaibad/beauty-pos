<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Models\StockMovement;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class StockMovementController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = StockMovement::with(['product', 'user']);

        if ($request->filled('product_id')) {
            $query->where('product_id', $request->product_id);
        }

        if ($request->filled('type')) {
            $query->where('type', $request->type);
        }

        if ($request->filled('from')) {
            $query->whereDate('created_at', '>=', $request->from);
        }

        if ($request->filled('to')) {
            $query->whereDate('created_at', '<=', $request->to);
        }

        $movements = $query->latest()->paginate($request->get('per_page', 20));

        return response()->json(['status' => 'success', 'data' => $movements]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'product_id' => 'required|exists:products,id',
            'type'       => 'required|in:in,out',
            'reason'     => 'required|in:purchase,sale,treatment_use,expired,damaged,opname,manual',
            'quantity'   => 'required|integer|min:1',
            'notes'      => 'nullable|string',
        ]);

        $product = Product::findOrFail($validated['product_id']);

        // Validasi stok cukup saat out
        if ($validated['type'] === 'out' && $product->stock < $validated['quantity']) {
            return response()->json([
                'status'  => 'error',
                'message' => "Stok tidak mencukupi. Stok saat ini: {$product->stock}",
            ], 422);
        }

        $stockBefore = $product->stock;
        $stockAfter  = $validated['type'] === 'in'
            ? $stockBefore + $validated['quantity']
            : $stockBefore - $validated['quantity'];

        $movement = StockMovement::create([
            ...$validated,
            'user_id'      => auth()->id(),
            'stock_before' => $stockBefore,
            'stock_after'  => $stockAfter,
        ]);

        // Update stok produk
        $product->update(['stock' => $stockAfter]);

        return response()->json([
            'status'  => 'success',
            'message' => 'Pergerakan stok berhasil dicatat',
            'data'    => $movement->load(['product', 'user']),
        ], 201);
    }
}
