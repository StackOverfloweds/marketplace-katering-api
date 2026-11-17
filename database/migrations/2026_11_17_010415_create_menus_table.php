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
        Schema::create('menus', function (Blueprint $table) {
            $table->uuid('id')->primary();

            $table->foreignUuid('merchant_profile_id')
            ->constrained('profiles')
            ->restrictOnDelete();

            $table->foreignUuid('category_id')
                ->constrained('categories')
                ->restrictOnDelete();
            


            $table->string('name', 150);
            $table->string('slug', 180);

            $table->text('description')->nullable();

            $table->string('photo')->nullable();

            $table->decimal('price',14,2);

            $table->boolean('is_available')->default(true);

            $table->timestamps();
            $table->softDeletes();

            $table->unique(['merchant_profile_id', 'slug']);

            $table->index([
                'merchant_profile_id',
                'is_available'
            ]);

            $table->index(['category_id', 'is_available']);

            
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('menus');
    }
};
