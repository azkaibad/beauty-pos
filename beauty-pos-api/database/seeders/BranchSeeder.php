<?php

namespace Database\Seeders;

use App\Models\Branch;
use Illuminate\Database\Seeder;

class BranchSeeder extends Seeder
{
    public function run(): void
    {
        Branch::firstOrCreate(
            ['name' => 'Cabang Pusat'],
            [
                'address' => 'Jl. Pusat Kecantikan No 1',
                'phone' => '081234567890',
                'email' => 'pusat@beautypos.com'
            ]
        );

        Branch::firstOrCreate(
            ['name' => 'Cabang Surabaya'],
            [
                'address' => 'Jl. Surabaya No 2',
                'phone' => '081234567891',
                'email' => 'surabaya@beautypos.com'
            ]
        );
    }
}
