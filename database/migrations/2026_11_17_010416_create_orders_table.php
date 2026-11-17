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
        Schema::create('orders', function (Blueprint $table) {
            $table->uuid('id')->primary();

            $table->string('order_number', 50)->unique();

            $table->foreignUuid('customer_profile_id')
            ->constrained('profiles')
            ->restrictOnDelete();

            $table->foreignUuid('merchant_profile_id')
                ->constrained('profiles')
                ->restrictOnDelete();

            $table->date('delivery_date');
            $table->text('delivery_address');

            $table->decimal('subtotal',14,2)->default(0);
            $table->decimal('total',14,2)->default(0);

            $table->string('status',30)->default('pending');
            $table->text('notes')->nullable();
            
            $table->timestamps();

            $table->index([
                'customer_profile_id',
                'status'
            ]);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('orders');
    }
};
