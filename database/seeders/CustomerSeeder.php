<?php

namespace Database\Seeders;

use App\Models\Profile;
use App\Models\User;
use Illuminate\Database\Seeder;

class CustomerSeeder extends Seeder
{
    /**
     * Seed customer accounts and profiles.
     */
    public function run(): void
    {
        $customers = [
            ['Bambang Saputra', 'customer01', 'customer01@example.com', '081300000001', 'Samarinda'],
            ['Citra Lestari', 'customer02', 'customer02@example.com', '081300000002', 'Balikpapan'],
            ['Dimas Prakoso', 'customer03', 'customer03@example.com', '081300000003', 'Tenggarong'],
            ['Eka Wulandari', 'customer04', 'customer04@example.com', '081300000004', 'Samarinda'],
            ['Farhan Akbar', 'customer05', 'customer05@example.com', '081300000005', 'Balikpapan'],
            ['Gita Permata', 'customer06', 'customer06@example.com', '081300000006', 'Bontang'],
            ['Hendra Wijaya', 'customer07', 'customer07@example.com', '081300000007', 'Samarinda'],
            ['Intan Maharani', 'customer08', 'customer08@example.com', '081300000008', 'Tenggarong'],
            ['Joko Susanto', 'customer09', 'customer09@example.com', '081300000009', 'Balikpapan'],
            ['Kartika Sari', 'customer10', 'customer10@example.com', '081300000010', 'Samarinda'],
        ];

        foreach ($customers as [$name, $username, $email, $phone, $city]) {
            $user = User::updateOrCreate(
                ['username' => $username],
                [
                    'password' => 'Password123!',
                    'role' => 'customer',
                    'is_active' => true,
                ]
            );

            Profile::updateOrCreate(
                ['user_id' => $user->id],
                [
                    'full_name' => $name,
                    'email' => $email,
                    'phone' => $phone,
                    'company_name' => null,
                    'contact_person' => null,
                    'address' => 'Jl. Contoh No. 15',
                    'city' => $city,
                    'description' => 'Akun customer dummy untuk pengujian marketplace.',
                ]
            );
        }
    }
}
