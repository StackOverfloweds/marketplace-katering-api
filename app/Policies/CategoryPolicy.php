<?php

namespace App\Policies;

use App\Models\Category;
use App\Models\User;

class CategoryPolicy
{
    /**
     * Determine whether the user can create a category.
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
     * Determine whether the user can update a category.
     *
     * @param User $user
     * @param Category $category
     * @return bool
     */
    public function update(User $user, Category $category): bool
    {
        return $user->role === 'merchant'
            && $user->is_active
            && $user->profile?->id === $category->merchant_profile_id;
    }

    /**
     * Determine whether the user can delete a category.
     *
     * @param User $user
     * @param Category $category
     * @return bool
     */
    public function delete(User $user, Category $category): bool
    {
        return $user->role === 'merchant'
            && $user->is_active
            && $user->profile?->id === $category->merchant_profile_id;
    }
}
