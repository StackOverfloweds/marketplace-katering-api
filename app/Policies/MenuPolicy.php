<?php

namespace App\Policies;

use App\Models\Menu;
use App\Models\User;

class MenuPolicy
{
    /**
     * Determine whether the user can view any menus.
     */
    public function viewAny(User $user): bool
    {
        return $user->is_active;
    }

    /**
     * Determine whether the user can view a menu.
     */
    public function view(User $user, Menu $menu): bool
    {
        return $menu->is_available || $this->ownsMenu($user, $menu);
    }

    /**
     * Determine whether the user can create menus.
     */
    public function create(User $user): bool
    {
        return $user->is_active
            && $user->role === 'merchant'
            && $user->profile !== null;
    }

    /**
     * Determine whether the user can update a menu.
     */
    public function update(User $user, Menu $menu): bool
    {
        return $this->ownsMenu($user, $menu);
    }

    /**
     * Determine whether the user can delete a menu.
     */
    public function delete(User $user, Menu $menu): bool
    {
        return $this->ownsMenu($user, $menu);
    }

    /**
     * Determine whether the user owns the menu.
     */
    private function ownsMenu(User $user, Menu $menu): bool
    {
        return $user->is_active
            && $user->role === 'merchant'
            && $user->profile !== null
            && $menu->merchant_profile_id === $user->profile->id;
    }
}