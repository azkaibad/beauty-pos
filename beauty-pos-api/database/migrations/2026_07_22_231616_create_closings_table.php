<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('closings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('cashier_id')->constrained('users')->cascadeOnDelete();
            $table->foreignId('approved_by')->nullable()->constrained('users')->nullOnDelete();
            $table->foreignId('branch_id')->nullable()->constrained()->nullOnDelete();
            $table->enum('shift', ['morning', 'evening']);
            $table->date('closing_date');
            $table->decimal('total_transactions', 14, 2)->default(0); // total dari sistem
            $table->decimal('total_actual', 14, 2)->default(0);       // total aktual dihitung kasir
            $table->decimal('difference', 14, 2)->default(0);         // selisih (aktual - sistem)
            $table->integer('total_count')->default(0);               // jumlah transaksi
            $table->enum('status', ['draft', 'submitted', 'approved', 'rejected'])->default('draft');
            $table->text('notes')->nullable();
            $table->timestamp('submitted_at')->nullable();
            $table->timestamp('approved_at')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('closings');
    }
};
