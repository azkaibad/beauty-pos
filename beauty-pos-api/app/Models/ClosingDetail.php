<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ClosingDetail extends Model
{
    protected $fillable = [
        'closing_id', 'payment_method_id',
        'system_amount', 'actual_amount', 'difference',
    ];

    protected $casts = [
        'system_amount' => 'decimal:2',
        'actual_amount' => 'decimal:2',
        'difference'    => 'decimal:2',
    ];

    public function closing(): BelongsTo       { return $this->belongsTo(Closing::class); }
    public function paymentMethod(): BelongsTo { return $this->belongsTo(PaymentMethod::class); }
}
