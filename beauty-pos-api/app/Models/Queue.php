<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Queue extends Model
{
    protected $fillable = [
        'customer_id', 'queue_type_id', 'doctor_id', 'branch_id',
        'queue_number', 'status', 'queue_date',
        'called_at', 'served_at', 'completed_at', 'notes',
    ];

    protected $casts = [
        'queue_date'   => 'date',
        'called_at'    => 'datetime',
        'served_at'    => 'datetime',
        'completed_at' => 'datetime',
    ];

    public function customer(): BelongsTo
    {
        return $this->belongsTo(Customer::class);
    }

    public function queueType(): BelongsTo
    {
        return $this->belongsTo(QueueType::class);
    }

    public function doctor(): BelongsTo
    {
        return $this->belongsTo(User::class, 'doctor_id');
    }

    public function branch(): BelongsTo
    {
        return $this->belongsTo(Branch::class);
    }

    /**
     * Generate nomor antrian berikutnya untuk hari ini.
     * Format: K-001, T-002, P-003 dst.
     */
    public static function generateNumber(QueueType $type, \DateTimeInterface $date): string
    {
        $count = static::where('queue_type_id', $type->id)
            ->whereDate('queue_date', $date)
            ->count();

        return $type->code . '-' . str_pad($count + 1, 3, '0', STR_PAD_LEFT);
    }
}
