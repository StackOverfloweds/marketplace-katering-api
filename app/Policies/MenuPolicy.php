<?php

namespace App\Policies;

use App\Models\Menu;
use App\Models\User;

class MenuPolicy
{
    /**
     * Determine whether the user can create a menu.
     *
     * @param User $user
     * @return bool
     */
    public function create(User $user): bool
    {
        return $user->role === 'merchant'
            && $user->is_active
            && $user->profile()->exists();
    }

    /**
     * Determine whether the user can update the given menu.
     *
     * @param User $user
     * @param Menu $menu
     * @return bool
     */
    public function update(User $user, Menu $menu): bool
    {
        return $user->role === 'merchant'
            && $user->is_active
            && $user->profile?->id === $menu->merchant_profile_id;
    }

    /**
     * Determine whether the user can delete the given menu.
     *
     * @param User $user
     * @param Menu $menu
     * @return bool
     */
    public function delete(User $user, Menu $menu): bool
    {
        return $user->role === 'merchant'
            && $user->is_active
            && $user->profile?->id === $menu->merchant_profile_id;
    }
}
