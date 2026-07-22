<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Closing extends Model
{
    protected $fillable = [
        'cashier_id', 'approved_by', 'branch_id', 'shift', 'closing_date',
        'total_transactions', 'total_actual', 'difference', 'total_count',
        'status', 'notes', 'submitted_at', 'approved_at',
    ];

    protected $casts = [
        'closing_date'      => 'date',
        'total_transactions' => 'decimal:2',
        'total_actual'      => 'decimal:2',
        'difference'        => 'decimal:2',
        'submitted_at'      => 'datetime',
        'approved_at'       => 'datetime',
    ];

    public function cashier(): BelongsTo    { return $this->belongsTo(User::class, 'cashier_id'); }
    public function approvedBy(): BelongsTo { return $this->belongsTo(User::class, 'approved_by'); }
    public function branch(): BelongsTo     { return $this->belongsTo(Branch::class); }
    public function details(): HasMany      { return $this->hasMany(ClosingDetail::class); }
}
