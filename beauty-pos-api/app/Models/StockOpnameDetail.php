<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class StockOpnameDetail extends Model
{
    protected $fillable = [
        'stock_opname_id', 'product_id',
        'system_stock', 'actual_stock', 'difference', 'notes',
    ];

    public function stockOpname(): BelongsTo { return $this->belongsTo(StockOpname::class); }
    public function product(): BelongsTo     { return $this->belongsTo(Product::class); }
}
