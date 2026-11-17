<?php

namespace Database\Seeders;

use App\Models\Profile;
use App\Models\User;
use Illuminate\Database\Seeder;

class MerchantSeeder extends Seeder
{
    /**
     * Seed merchant accounts and profiles.
     */
    public function run(): void
    {
        $merchants = [
            [
                'username' => 'merchant01',
                'full_name' => 'Andi Pratama',
                'company_name' => 'Katering Nusantara',
                'email' => 'merchant01@example.com',
                'phone' => '081200000001',
                'city' => 'Samarinda',
            ],
            [
                'username' => 'merchant02',
                'full_name' => 'Siti Rahmawati',
                'company_name' => 'Dapur Bunda',
                'email' => 'merchant02@example.com',
                'phone' => '081200000002',
                'city' => 'Balikpapan',
            ],
            [
                'username' => 'merchant03',
                'full_name' => 'Budi Santoso',
                'company_name' => 'Berkah Catering',
                'email' => 'merchant03@example.com',
                'phone' => '081200000003',
                'city' => 'Tenggarong',
            ],
            [
                'username' => 'merchant04',
                'full_name' => 'Dewi Anggraini',
                'company_name' => 'Rasa Nusantara',
                'email' => 'merchant04@example.com',
                'phone' => '081200000004',
                'city' => 'Samarinda',
            ],
            [
                'username' => 'merchant05',
                'full_name' => 'Rizky Maulana',
                'company_name' => 'Kalimantan Food',
                'email' => 'merchant05@example.com',
                'phone' => '081200000005',
                'city' => 'Balikpapan',
            ],
            [
                'username' => 'merchant06',
                'full_name' => 'Maya Sari',
                'company_name' => 'Dapur Sehat',
                'email' => 'merchant06@example.com',
                'phone' => '081200000006',
                'city' => 'Samarinda',
            ],
            [
                'username' => 'merchant07',
                'full_name' => 'Agus Setiawan',
                'company_name' => 'Cita Rasa Catering',
                'email' => 'merchant07@example.com',
                'phone' => '081200000007',
                'city' => 'Bontang',
            ],
            [
                'username' => 'merchant08',
                'full_name' => 'Putri Amelia',
                'company_name' => 'Sweet Kitchen',
                'email' => 'merchant08@example.com',
                'phone' => '081200000008',
                'city' => 'Samarinda',
            ],
            [
                'username' => 'merchant09',
                'full_name' => 'Fajar Ramadhan',
                'company_name' => 'Warung Premium',
                'email' => 'merchant09@example.com',
                'phone' => '081200000009',
                'city' => 'Tenggarong',
            ],
            [
                'username' => 'merchant10',
                'full_name' => 'Nadia Putri',
                'company_name' => 'Healthy Meal',
                'email' => 'merchant10@example.com',
                'phone' => '081200000010',
                'city' => 'Balikpapan',
            ],
        ];

        foreach ($merchants as $merchant) {
            $user = User::updateOrCreate(
                ['username' => $merchant['username']],
                [
                    'password' => 'Password123!',
                    'role' => 'merchant',
                    'is_active' => true,
                ]
            );

            Profile::updateOrCreate(
                ['user_id' => $user->id],
                [
                    'full_name' => $merchant['full_name'],
                    'email' => $merchant['email'],
                    'phone' => $merchant['phone'],
                    'company_name' => $merchant['company_name'],
                    'contact_person' => $merchant['full_name'],
                    'address' => 'Jl. ' . $merchant['company_name'] . ' No. 10',
                    'city' => $merchant['city'],
                    'description' => 'Penyedia layanan katering dan makanan berkualitas.',
                ]
            );
        }
    }
}
