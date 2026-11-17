<?php

namespace App\Services\Invoice;

use App\Models\Invoice;
use App\Models\User;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;

class InvoiceQueryService
{
    /**
     * Get invoices belonging to the authenticated user.
     */
    public function getUserInvoices(
        User $user,
        int $perPage = 10
    ): LengthAwarePaginator {
        $profileId = $user->profile->id;
    
        return Invoice::query()
            ->with([
                'order.orderItems',
                'order.customerProfile',
                'order.merchantProfile',
            ])
            ->whereHas('order', function ($query) use ($user, $profileId) {
                if ($user->role === 'customer') {
                    $query->where('customer_profile_id', $profileId);
                } elseif ($user->role === 'merchant') {
                    $query->where('merchant_profile_id', $profileId);
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
