<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Payment extends Model
{
    protected $fillable = [
        'transaction_id', 'payment_method_id', 'amount',
        'reference_number', 'notes',
    ];

    protected $casts = [
        'amount' => 'decimal:2',
    ];

    public function transaction(): BelongsTo    { return $this->belongsTo(Transaction::class); }
    public function paymentMethod(): BelongsTo  { return $this->belongsTo(PaymentMethod::class); }
}
