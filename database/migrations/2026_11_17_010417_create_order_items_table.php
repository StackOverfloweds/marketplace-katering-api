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
        Schema::create('order_items', function (Blueprint $table) {
            $table->uuid('id')->primary();

            $table->foreignUuid('order_id')
            ->constrained('orders')
            ->cascadeOnDelete();

            $table->foreignUuid('menu_id')
                ->nullable()
                ->constrained('menus')
                ->nullOnDelete();

            // Snapshot Menu ketika transaksi dibuat
            $table->string('menu_name',150);
            $table->decimal('price',14,2);
            $table->unsignedInteger('quantity');
            $table->decimal('subtotal',14,2);
            $table->timestamps();

            $table->index('menu_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('order_items');
    }
};
