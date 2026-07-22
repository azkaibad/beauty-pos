<?php

namespace Database\Seeders;

use App\Models\PaymentMethod;
use Illuminate\Database\Seeder;

class PaymentMethodSeeder extends Seeder
{
    public function run(): void
    {
        $methods = [
            ['name' => 'Tunai (Cash)',       'code' => 'CASH',      'sort_order' => 1],
            ['name' => 'Transfer Bank',      'code' => 'TRANSFER',  'sort_order' => 2],
            ['name' => 'QRIS',               'code' => 'QRIS',      'sort_order' => 3],
            ['name' => 'Kurir Transfer',     'code' => 'KURIR_TF',  'sort_order' => 4],
            ['name' => 'Split Payment',      'code' => 'SPLIT',     'sort_order' => 5],
        ];

        foreach ($methods as $method) {
            PaymentMethod::firstOrCreate(['code' => $method['code']], $method);
        }
    }
}
