<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Transaction extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'transaction_number', 'customer_id', 'cashier_id', 'doctor_id',
        'queue_id', 'branch_id', 'subtotal', 'discount_amount',
        'discount_percent', 'total', 'paid_amount', 'change_amount',
        'status', 'payment_type', 'notes', 'paid_at',
    ];

    protected $casts = [
        'subtotal'         => 'decimal:2',
        'discount_amount'  => 'decimal:2',
        'discount_percent' => 'decimal:2',
        'total'            => 'decimal:2',
        'paid_amount'      => 'decimal:2',
        'change_amount'    => 'decimal:2',
        'paid_at'          => 'datetime',
    ];

    public function customer(): BelongsTo   { return $this->belongsTo(Customer::class); }
    public function cashier(): BelongsTo    { return $this->belongsTo(User::class, 'cashier_id'); }
    public function doctor(): BelongsTo     { return $this->belongsTo(User::class, 'doctor_id'); }
    public function queue(): BelongsTo      { return $this->belongsTo(Queue::class); }
    public function branch(): BelongsTo     { return $this->belongsTo(Branch::class); }
    public function items(): HasMany        { return $this->hasMany(TransactionItem::class); }
    public function payments(): HasMany     { return $this->hasMany(Payment::class); }

    /**
     * Generate nomor transaksi unik per hari.
     * Format: TRX-YYYYMMDD-001
     */
    public static function generateNumber(): string
    {
        $prefix = 'TRX-' . now()->format('Ymd') . '-';
        $count  = static::whereDate('created_at', today())->count();

        return $prefix . str_pad($count + 1, 3, '0', STR_PAD_LEFT);
    }
}
