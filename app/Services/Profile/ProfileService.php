<?php

namespace App\Services\Profile;

use App\Models\Profile;
use App\Models\User;
use Illuminate\Support\Facades\DB;

/**
 * Handle user profile management.
 *
 * Responsible for retrieving and updating user profile data
 * for merchant and customer accounts.
 */
class ProfileService
{
    /**
     * Retrieve the authenticated user's profile.
     *
     * @param User $user Authenticated user
     * @return Profile
     */
    public function getProfile(User $user): Profile
    {
        return $user->profile()->firstOrFail();
    }

    /**
     * Update the authenticated user's profile.
     *
     * Updates profile attributes within a database transaction
     * to ensure database consistency.
     *
     * @param User $user Authenticated user
     * @param array $data Validated profile data
     * @return Profile
     */
    public function updateProfile(
        User $user,
        array $data
    ): Profile {
        return DB::transaction(function () use ($user, $data) {
            $profile = $user->profile()->firstOrFail();

            $profile->update($data);

            return $profile->refresh();
        });
    }
}
