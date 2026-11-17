<?php

namespace App\Http\Controllers\Api\V1\Profile;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Services\Profile\ProfileService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

/**
 * Handle merchant and customer profile endpoints.
 */
class ProfileController extends Controller
{
    /**
     * Initialize profile controller dependencies.
     *
     * @param ProfileService $profiles
     */
    public function __construct(
        private ProfileService $profiles
    ) {}

    /**
     * Retrieve the authenticated user's profile.
     *
     * @param Request $request
     * @return JsonResponse
     */
    public function show(Request $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user('api');

        $profile = $this->profiles->getProfile($user);

        return response()->json([
            'success' => true,
            'message' => 'Profil berhasil diambil.',
            'data' => $profile,
        ]);
    }

    /**
     * Update the authenticated user's profile.
     *
     * Validation rules are adjusted according to the
     * authenticated user's role.
     *
     * @param Request $request
     * @return JsonResponse
     */
    public function update(Request $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user('api');

        $profile = $this->profiles->getProfile($user);

        $validated = $request->validate([
            'full_name' => [
                'sometimes',
                'required',
                'string',
                'max:150',
            ],

            'email' => [
                'sometimes',
                'required',
                'email',
                'max:255',
                Rule::unique('profiles', 'email')
                    ->ignore($profile->id),
            ],

            'phone' => [
                'sometimes',
                'required',
                'string',
                'max:20',
            ],

            'company_name' => $user->role === 'merchant'
                ? ['sometimes', 'required', 'string', 'max:150']
                : ['prohibited'],

            'contact_person' => [
                'sometimes',
                'nullable',
                'string',
                'max:150',
            ],

            'address' => [
                'sometimes',
                'nullable',
                'string',
            ],

            'city' => [
                'sometimes',
                'nullable',
                'string',
                'max:100',
            ],

            'description' => [
                'sometimes',
                'nullable',
                'string',
                'max:1000',
            ],
        ]);

        $updatedProfile = $this->profiles->updateProfile(
            $user,
            $validated
        );

        return response()->json([
            'success' => true,
            'message' => 'Profil berhasil diperbarui.',
            'data' => $updatedProfile,
        ]);
    }
}
