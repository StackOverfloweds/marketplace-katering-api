
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
        Schema::table('categories', function (Blueprint $table) {
            $table->foreignUuid('merchant_profile_id')
                ->nullable()
                ->constrained('profiles')
                ->restrictOnDelete();

            $table->index([
                'merchant_profile_id',
                'is_active',
            ]);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('categories', function (Blueprint $table) {
            $table->dropForeign(['merchant_profile_id']);
            $table->dropIndex([
                'merchant_profile_id',
                'is_active',
            ]);

            $table->dropColumn('merchant_profile_id');
        });
    }
};
