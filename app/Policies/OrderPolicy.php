<?php

namespace App\Policies;

use App\Models\Order;
use App\Models\User;

class OrderPolicy
{
    /**
     * Determine whether the user can view any orders.
     *
     * @param User $user
     * @return bool
     */
    public function viewAny(User $user): bool
    {
        return in_array($user->role, ['customer', 'merchant'], true)
            && $user->is_active;
    }

    /**
     * Determine whether the user can view the order.
     *
     * @param User $user
     * @param Order $order
     * @return bool
     */
    public function view(User $user, Order $order): bool
    {
        if (!$user->is_active) {
            return false;
        }

        $profileId = $user->profile?->id;

        if (!$profileId) {
            return false;
        }

        return match ($user->role) {
            'customer' => $order->customer_profile_id === $profileId,
            'merchant' => $order->merchant_profile_id === $profileId,
            default => false,
        };
    }

    /**
     * Determine whether the user can create an order.
     *
     * @param User $user
     * @return bool
     */
    public function create(User $user): bool
    {
        return $user->role === 'customer'
            && $user->is_active
            && $user->profile()->exists();
    }

    /**
     * Determine whether the customer can cancel the order.
     *
     * @param User $user
     * @param Order $order
     * @return bool
     */
    public function cancel(User $user, Order $order): bool
    {
        return $user->is_active
            && $user->role === 'customer'
            && $order->customer_profile_id === $user->profile?->id
            && $order->status === 'pending';
    }

    /**
     * Determine whether the merchant can update the order status.
     *
     * @param User $user
     * @param Order $order
     * @return bool
     */
    public function updateStatus(User $user, Order $order): bool
    {
        return $user->is_active
            && $user->role === 'merchant'
            && $order->merchant_profile_id === $user->profile?->id;
    }
}
