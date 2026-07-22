<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Customer extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'name', 'phone', 'email', 'birth_date', 'gender',
        'address', 'photo', 'allergy', 'notes', 'is_active',
    ];

    protected $casts = [
        'birth_date' => 'date',
        'is_active'  => 'boolean',
    ];

    public function medicalRecords(): HasMany
    {
        return $this->hasMany(MedicalRecord::class);
    }

    public function latestMedicalRecord()
    {
        return $this->hasOne(MedicalRecord::class)->latestOfMany();
    }

    public function getAgeAttribute(): ?int
    {
        return $this->birth_date?->age;
    }
}
