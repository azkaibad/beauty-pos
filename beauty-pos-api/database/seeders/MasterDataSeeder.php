<?php

namespace Database\Seeders;

use App\Models\CompanySetting;
use App\Models\ShiftSetting;
use Illuminate\Database\Seeder;

class MasterDataSeeder extends Seeder
{
    public function run(): void
    {
        // Payment Methods sudah di PaymentMethodSeeder

        // Company Settings
        CompanySetting::firstOrCreate([], [
            'clinic_name'            => 'Beauty Clinic',
            'address'                => 'Jl. Contoh No. 1, Kota',
            'phone'                  => '0812-3456-7890',
            'email'                  => 'info@beautyclinic.com',
            'receipt_footer'         => 'Terima kasih atas kunjungan Anda! Sampai jumpa kembali.',
            'print_logo_on_receipt'  => true,
            'print_cashier_name'     => true,
            'print_doctor_name'      => true,
        ]);

        // Shift Settings
        $shifts = [
            [
                'shift'      => 'morning',
                'label'      => 'Shift Siang',
                'start_time' => '08:00:00',
                'end_time'   => '13:00:00',
                'is_active'  => true,
            ],
            [
                'shift'      => 'evening',
                'label'      => 'Shift Malam',
                'start_time' => '15:00:00',
                'end_time'   => '20:00:00',
                'is_active'  => true,
            ],
        ];

        foreach ($shifts as $shift) {
            ShiftSetting::firstOrCreate(['shift' => $shift['shift']], $shift);
        }
    }
}
