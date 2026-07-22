<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('closing_details', function (Blueprint $table) {
            $table->id();
            $table->foreignId('closing_id')->constrained()->cascadeOnDelete();
            $table->foreignId('payment_method_id')->constrained()->cascadeOnDelete();
            $table->decimal('system_amount', 14, 2)->default(0);  // dari sistem
            $table->decimal('actual_amount', 14, 2)->default(0);  // diinput kasir
            $table->decimal('difference', 14, 2)->default(0);     // selisih per metode
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('closing_details');
    }
};
