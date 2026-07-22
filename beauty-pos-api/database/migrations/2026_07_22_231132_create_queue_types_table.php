<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('queue_types', function (Blueprint $table) {
            $table->id();
            $table->string('name');           // Konsultasi, Treatment, Pembelian
            $table->string('code', 10);       // K, T, P
            $table->string('color', 20)->default('#6DBF8A'); // warna badge
            $table->boolean('is_active')->default(true);
            $table->integer('sort_order')->default(0);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('queue_types');
    }
};
