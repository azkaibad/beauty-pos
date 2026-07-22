<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('medical_records', function (Blueprint $table) {
            $table->id();
            $table->foreignId('customer_id')->constrained()->cascadeOnDelete();
            $table->foreignId('doctor_id')->nullable()->constrained('users')->nullOnDelete();
            $table->date('visit_date');
            $table->text('complaint')->nullable();         // keluhan
            $table->text('diagnosis')->nullable();
            $table->text('action')->nullable();            // tindakan
            $table->text('recommendation')->nullable();   // rekomendasi dokter
            $table->text('notes')->nullable();
            // Vital signs (opsional)
            $table->string('blood_pressure', 20)->nullable();  // tekanan darah, e.g. "120/80"
            $table->decimal('weight', 5, 1)->nullable();       // berat badan (kg)
            $table->decimal('height', 5, 1)->nullable();       // tinggi badan (cm)
            // Riwayat alergi
            $table->text('allergy_notes')->nullable();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('medical_records');
    }
};
