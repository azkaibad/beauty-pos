<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Models\StockMovement;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Product::with('category');

        if ($request->filled('search')) {
            $query->where(function ($q) use ($request) {
                $q->where('name', 'like', "%{$request->search}%")
                  ->orWhere('code', 'like', "%{$request->search}%");
            });
        }

        if ($request->filled('type')) {
            $query->where('type', $request->type);
        }

        if ($request->filled('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        if ($request->filled('is_active')) {
            $query->where('is_active', $request->boolean('is_active'));
        }

        $products = $query->latest()->paginate($request->get('per_page', 15));

        return response()->json(['status' => 'success', 'data' => $products]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'category_id'    => 'nullable|exists:categories,id',
            'code'           => 'nullable|string|max:50|unique:products',
            'name'           => 'required|string|max:255',
            'type'           => 'required|in:retail,treatment',
            'description'    => 'nullable|string',
            'purchase_price' => 'nullable|numeric|min:0',
            'selling_price'  => 'required|numeric|min:0',
            'stock'          => 'nullable|integer|min:0',
            'min_stock'      => 'nullable|integer|min:0',
            'unit'           => 'nullable|string|max:20',
            'photo'          => 'nullable|image|max:2048',
        ]);

        if ($request->hasFile('photo')) {
            $validated['photo'] = $request->file('photo')->store('products', 'public');
        }

        $product = Product::create($validated);

        // Catat stok awal jika ada
        if (($validated['stock'] ?? 0) > 0) {
            StockMovement::create([
                'product_id'   => $product->id,
                'user_id'      => auth()->id(),
                'type'         => 'in',
                'reason'       => 'purchase',
                'quantity'     => $product->stock,
                'stock_before' => 0,
                'stock_after'  => $product->stock,
                'notes'        => 'Stok awal saat produk dibuat',
            ]);
        }

        return response()->json([
            'status'  => 'success',
            'message' => 'Produk berhasil ditambahkan',
            'data'    => $product->load('category'),
        ], 201);
    }

    public function show(Product $product): JsonResponse
    {
        $product->load('category', 'stockMovements');

        return response()->json(['status' => 'success', 'data' => $product]);
    }

    public function update(Request $request, Product $product): JsonResponse
    {
        $validated = $request->validate([
            'category_id'    => 'nullable|exists:categories,id',
            'code'           => 'nullable|string|max:50|unique:products,code,' . $product->id,
            'name'           => 'sometimes|string|max:255',
            'type'           => 'sometimes|in:retail,treatment',
            'description'    => 'nullable|string',
            'purchase_price' => 'nullable|numeric|min:0',
            'selling_price'  => 'sometimes|numeric|min:0',
            'min_stock'      => 'nullable|integer|min:0',
            'unit'           => 'nullable|string|max:20',
            'is_active'      => 'nullable|boolean',
            'photo'          => 'nullable|image|max:2048',
        ]);

        if ($request->hasFile('photo')) {
            $validated['photo'] = $request->file('photo')->store('products', 'public');
        }

        $product->update($validated);

        return response()->json([
            'status'  => 'success',
            'message' => 'Produk berhasil diupdate',
            'data'    => $product->load('category'),
        ]);
    }

    public function destroy(Product $product): JsonResponse
    {
        $product->delete();

        return response()->json(['status' => 'success', 'message' => 'Produk berhasil dihapus']);
    }

    public function lowStock(): JsonResponse
    {
        $products = Product::with('category')
            ->whereColumn('stock', '<=', 'min_stock')
            ->where('is_active', true)
            ->get();

        return response()->json(['status' => 'success', 'data' => $products]);
    }
}
