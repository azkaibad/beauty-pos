<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\MorphTo;

class TransactionItem extends Model
{
    protected $fillable = [
        'transaction_id', 'itemable_type', 'itemable_id',
        'name', 'price', 'quantity', 'discount_amount', 'subtotal', 'notes',
    ];

    protected $casts = [
        'price'           => 'decimal:2',
        'discount_amount' => 'decimal:2',
        'subtotal'        => 'decimal:2',
    ];

    public function transaction(): BelongsTo { return $this->belongsTo(Transaction::class); }
    public function itemable(): MorphTo      { return $this->morphTo(); }
}
