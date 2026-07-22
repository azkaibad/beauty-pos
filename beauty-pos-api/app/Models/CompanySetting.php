<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CompanySetting extends Model
{
    protected $fillable = [
        'clinic_name', 'address', 'phone', 'email', 'logo',
        'tagline', 'receipt_footer', 'print_logo_on_receipt',
        'print_cashier_name', 'print_doctor_name',
    ];

    protected $casts = [
        'print_logo_on_receipt' => 'boolean',
        'print_cashier_name'    => 'boolean',
        'print_doctor_name'     => 'boolean',
    ];

    /**
     * Get or create the single company settings record.
     */
    public static function getInstance(): static
    {
        return static::firstOrCreate([], [
            'clinic_name' => 'Beauty Clinic',
        ]);
    }
}
