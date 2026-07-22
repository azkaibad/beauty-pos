<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class MedicalRecord extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'customer_id', 'doctor_id', 'visit_date', 'complaint', 'diagnosis',
        'action', 'recommendation', 'notes', 'allergy_notes',
        'blood_pressure', 'weight', 'height',
    ];

    protected $casts = [
        'visit_date' => 'date',
        'weight'     => 'decimal:1',
        'height'     => 'decimal:1',
    ];

    public function customer(): BelongsTo
    {
        return $this->belongsTo(Customer::class);
    }

    public function doctor(): BelongsTo
    {
        return $this->belongsTo(User::class, 'doctor_id');
    }

    public function photos(): HasMany
    {
        return $this->hasMany(MedicalPhoto::class);
    }

    public function beforePhotos(): HasMany
    {
        return $this->hasMany(MedicalPhoto::class)->where('photo_type', 'before');
    }

    public function afterPhotos(): HasMany
    {
        return $this->hasMany(MedicalPhoto::class)->where('photo_type', 'after');
    }
}
