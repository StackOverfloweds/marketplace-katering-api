<?php

namespace App\Services\Invoice;

use App\Models\Invoice;
use App\Models\User;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;

class InvoiceQueryService
{
    
    /**
     * Get invoices belonging to the authenticated user.
     *
     * @param User $user
     * @param int $perPage
     * @return LengthAwarePaginator
     */
    public function getUserInvoices(
        User $user,
        int $perPage = 10
    ): LengthAwarePaginator {
        $profile = $user->profile;

        if (!$profile) {
            throw \Illuminate\Validation\ValidationException::withMessages([
                'profile' => 'Profil pengguna tidak ditemukan.',
            ]);
        }

        return Invoice::query()
            ->with([
                'order.orderItems',
                'order.customerProfile',
                'order.merchantProfile',
            ])
            ->whereHas('order', function ($query) use ($user, $profile) {
                if ($user->role === 'customer') {
                    $query->where('customer_profile_id', $profile->id);
                } elseif ($user->role === 'merchant') {
                    $query->where('merchant_profile_id', $profile->id);
                } else {
                    $query->whereRaw('1 = 0');
                }
            })
            ->orderByDesc('invoice_date')
            ->paginate($perPage);
    }


    /**
     * Find an invoice with its related order data.
     */
    public function getInvoiceDetail(Invoice $invoice): Invoice
    {
        return $invoice->load([
            'order.orderItems',
            'order.customerProfile',
            'order.merchantProfile',
        ]);
    }
}
