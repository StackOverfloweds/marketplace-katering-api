<?php

namespace App\Policies;

use App\Models\Invoice;
use App\Models\User;

class InvoicePolicy
{
    /**
     * Determine whether the user can view invoices.
     */
    public function viewAny(User $user): bool
    {
        return $user->is_active
            && in_array($user->role, ['customer', 'merchant'], true)
            && $user->profile !== null;
    }

    /**
     * Determine whether the user can view an invoice.
     */
    public function view(User $user, Invoice $invoice): bool
    {
        if (! $user->is_active || ! $user->profile) {
            return false;
        }

        $order = $invoice->order;

        if (! $order) {
            return false;
        }

        return match ($user->role) {
            'customer' => $order->customer_profile_id === $user->profile->id,
            'merchant' => $order->merchant_profile_id === $user->profile->id,
            default => false,
        };
    }
}
