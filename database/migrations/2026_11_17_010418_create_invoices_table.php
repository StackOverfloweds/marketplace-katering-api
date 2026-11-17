<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('invoices', function (Blueprint $table) {
            $table->uuid('id')->primary();

            $table->foreignUuid('order_id')
                ->unique()
                ->constrained('orders')
                ->restrictOnDelete();

            $table->string('invoice_number', 50)->unique();

            $table->date('invoice_date');
            $table->decimal('subtotal',14,2);
            $table->decimal('total',14,2);

            $table->string('status',30)->default('issued');

            $table->timestamp('paid_at')->nullable();
            $table->index('status');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('invoices');
    }
};
