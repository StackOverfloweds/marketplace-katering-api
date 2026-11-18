<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Profile;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class CategorySeeder extends Seeder
{
    /**
     * Seed categories for all merchant profiles.
     */
    public function run(): void
    {
        $categories = [
            'Makanan Berat',
            'Makanan Ringan',
            'Minuman',
            'Paket Nasi Kotak',
        ];

        $merchants = User::where('role', 'merchant')
            ->with('profile')
            ->get();

        foreach ($merchants as $merchant) {
            $profile = $merchant->profile;

            if (!$profile) {
                continue;
            }

            $merchantNumber = substr(
                preg_replace('/\D/', '', $merchant->username),
                -2
            );

            foreach ($categories as $index => $name) {
                $slug = Str::slug($name . '-merchant-' . $merchantNumber);

                Category::updateOrCreate(
                    ['slug' => $slug],
                    [
                        'merchant_profile_id' => $profile->id,
                        'name' => $name,
                        'description' => 'Kategori ' . strtolower($name) . ' dari ' . $profile->company_name,
                        'is_active' => true,
                        'sort_order' => $index + 1,
                    ]
                );
            }
        }
    }
}
