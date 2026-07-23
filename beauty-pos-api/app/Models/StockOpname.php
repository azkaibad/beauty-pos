<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class StockOpname extends Model
{
    protected $fillable = [
        'created_by', 'approved_by', 'branch_id',
        'opname_number', 'opname_date', 'status',
        'notes', 'submitted_at', 'approved_at',
    ];

    protected $casts = [
        'opname_date'  => 'date',
        'submitted_at' => 'datetime',
        'approved_at'  => 'datetime',
    ];

    public function createdBy(): BelongsTo { return $this->belongsTo(User::class, 'created_by'); }
    public function approvedBy(): BelongsTo { return $this->belongsTo(User::class, 'approved_by'); }
    public function branch(): BelongsTo     { return $this->belongsTo(Branch::class); }
    public function details(): HasMany      { return $this->hasMany(StockOpnameDetail::class); }

    public static function generateNumber(): string
    {
        $prefix = 'OPN-' . now()->format('Ymd') . '-';
        $count  = static::whereDate('created_at', today())->count();

        return $prefix . str_pad($count + 1, 3, '0', STR_PAD_LEFT);
    }
}
