<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Menu;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class MenuSeeder extends Seeder
{
    /**
     * Seed menu items for every merchant category.
     */
    public function run(): void
    {
        $menuData = [
            'Makanan Berat' => [
                ['Nasi Ayam Bakar', 25000],
                ['Nasi Rendang', 30000],
                ['Nasi Goreng Spesial', 22000],
                ['Ayam Geprek', 20000],
                ['Nasi Ikan Goreng', 25000],
            ],
            'Makanan Ringan' => [
                ['Risoles Mayo', 5000],
                ['Pastel Ayam', 5000],
                ['Lumpia Sayur', 6000],
                ['Kentang Goreng', 15000],
                ['Pisang Cokelat', 12000],
            ],
            'Minuman' => [
                ['Es Teh Manis', 5000],
                ['Jus Alpukat', 15000],
                ['Es Jeruk', 8000],
                ['Kopi Susu', 18000],
                ['Es Cokelat', 12000],
            ],
            'Paket Nasi Kotak' => [
                ['Paket Nasi Ayam', 25000],
                ['Paket Nasi Rendang', 35000],
                ['Paket Nasi Ikan', 28000],
                ['Paket Nasi Telur', 18000],
                ['Paket Nasi Komplit', 40000],
            ],
        ];

        $categories = Category::whereNotNull('merchant_profile_id')
            ->get();

        foreach ($categories as $category) {
            $items = $menuData[$category->name] ?? [];

            foreach ($items as $index => [$name, $price]) {
                $slug = Str::slug($name);

                Menu::updateOrCreate(
                    [
                        'merchant_profile_id' => $category->merchant_profile_id,
                        'slug' => $slug,
                    ],
                    [
                        'category_id' => $category->id,
                        'name' => $name,
                        'description' => $name . ' dibuat dengan bahan pilihan dan berkualitas.',
                        'photo' => null,
                        'price' => $price,
                        'is_available' => true,
                    ]
                );
            }
        }
    }
}
