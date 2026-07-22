<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class FollowUp extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'customer_id', 'assigned_to', 'medical_record_id',
        'title', 'notes', 'due_date', 'priority', 'status',
        'result', 'contacted_at',
    ];

    protected $casts = [
        'due_date'     => 'date',
        'contacted_at' => 'datetime',
    ];

    public function customer(): BelongsTo       { return $this->belongsTo(Customer::class); }
    public function assignedTo(): BelongsTo     { return $this->belongsTo(User::class, 'assigned_to'); }
    public function medicalRecord(): BelongsTo  { return $this->belongsTo(MedicalRecord::class); }

    public function getIsOverdueAttribute(): bool
    {
        return $this->status === 'pending' && $this->due_date->isPast();
    }
}
