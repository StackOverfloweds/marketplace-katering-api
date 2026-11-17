<?php

namespace App\Policies;

use App\Models\Category;
use App\Models\User;

class CategoryPolicy
{
    /**
     * Determine whether the user can view any categories.
     */
    public function viewAny(User $user): bool
    {
        return $user->is_active;
    }

    /**
     * Determine whether the user can view a category.
     */
    public function view(User $user, Category $category): bool
    {
        return $category->is_active || $this->ownsCategory($user, $category);
    }

    /**
     * Determine whether the user can create categories.
     */
    public function create(User $user): bool
    {
        return $user->is_active
            && $user->role === 'merchant'
            && $user->profile !== null;
    }

    /**
     * Determine whether the user can update a category.
     */
    public function update(User $user, Category $category): bool
    {
        return $this->ownsCategory($user, $category);
    }

    /**
     * Determine whether the user can delete a category.
     */
    public function delete(User $user, Category $category): bool
    {
        return $this->ownsCategory($user, $category);
    }

    /**
     * Determine whether the user owns the category.
     */
    private function ownsCategory(User $user, Category $category): bool
    {
        return $user->is_active
            && $user->role === 'merchant'
            && $user->profile !== null
            && $category->merchant_profile_id === $user->profile->id;
    }
}