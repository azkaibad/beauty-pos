<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ExpenseRequest extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'requested_by', 'approved_by', 'branch_id', 'title', 'description',
        'amount', 'category', 'status', 'bukti', 'reject_reason', 'approved_at',
    ];

    protected $casts = [
        'amount'      => 'decimal:2',
        'approved_at' => 'datetime',
    ];

    public function requestedBy(): BelongsTo { return $this->belongsTo(User::class, 'requested_by'); }
    public function approvedBy(): BelongsTo  { return $this->belongsTo(User::class, 'approved_by'); }
    public function branch(): BelongsTo      { return $this->belongsTo(Branch::class); }
}
