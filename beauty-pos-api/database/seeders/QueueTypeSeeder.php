<?php

namespace Database\Seeders;

use App\Models\QueueType;
use Illuminate\Database\Seeder;

class QueueTypeSeeder extends Seeder
{
    public function run(): void
    {
        $types = [
            ['name' => 'Konsultasi', 'code' => 'K', 'color' => '#4FC3F7', 'sort_order' => 1],
            ['name' => 'Treatment',  'code' => 'T', 'color' => '#F48FB1', 'sort_order' => 2],
            ['name' => 'Pembelian',  'code' => 'P', 'color' => '#A5D6A7', 'sort_order' => 3],
        ];

        foreach ($types as $type) {
            QueueType::firstOrCreate(['code' => $type['code']], $type);
        }
    }
}
