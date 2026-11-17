<?php

namespace App\Http\Controllers\Api\V1\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Services\Auth\AuthenticationService;
use App\Services\Auth\AuthSessionService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use PHPOpenSourceSaver\JWTAuth\Facades\JWTAuth;

class AuthController extends Controller
{
    /**
     * Initialize authentication controller dependencies.
     *
     * @param AuthenticationService $authentication
     * @param AuthSessionService $sessions
     */
    public function __construct(
        private AuthenticationService $authentication,
        private AuthSessionService $sessions
    ) {}

    /**
     * Register a new customer or merchant account.
     *
     * Creates a user account and its associated profile,
     * then generates JWT access and refresh tokens.
     *
     * @param Request $request
     * @return JsonResponse
     */
    public function register(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'username' => [
                'required', 'string', 'min:4', 'max:50',
                'unique:users,username'
            ],
            'password' => [
                'required', 'string', 'min:8', 'confirmed'
            ],
            'role' => [
                'required', Rule::in(['merchant', 'customer'])
            ],
            'full_name' => ['required', 'string', 'max:150'],
            'email' => [
                'required', 'email', 'max:255',
                'unique:profiles,email'
            ],
            'phone' => ['required', 'string', 'max:20'],
            'company_name' => ['nullable', 'string', 'max:150'],
            'contact_person' => ['nullable', 'string', 'max:150'],
            'address' => ['nullable', 'string'],
            'city' => ['nullable', 'string', 'max:100'],
            'device_name' => ['nullable', 'string', 'max:100'],
        ]);

        $result = $this->authentication->register(
            $validated,
            $this->deviceMetadata($request, $validated)
        );

        return response()->json([
            'success' => true,
            'message' => 'Registrasi berhasil.',
            'data' => $result,
        ], 201);
    }

    /**
     * Authenticate a user using username and password.
     *
     * If the credentials are valid, creates a Redis session
     * and returns JWT access and refresh tokens.
     *
     * @param Request $request
     * @return JsonResponse
     */
    public function login(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'username' => ['required', 'string'],
            'password' => ['required', 'string'],
            'device_name' => ['nullable', 'string', 'max:100'],
        ]);

        $result = $this->authentication->login(
            $validated,
            $this->deviceMetadata($request, $validated)
        );

        return response()->json([
            'success' => true,
            'message' => 'Login berhasil.',
            'data' => $result,
        ]);
    }

    /**
     * Retrieve the authenticated user's information.
     *
     * Returns the user identity and associated profile
     * using the authenticated API guard.
     *
     * @param Request $request
     * @return JsonResponse
     */
    public function me(Request $request): JsonResponse
    {
        /** @var User|null $user */
        $user = $request->user('api');

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User tidak ditemukan.',
            ], 401);
        }

        $user->load('profile');

        return response()->json([
            'success' => true,
            'data' => [
                'id' => $user->id,
                'username' => $user->username,
                'role' => $user->role,
                'profile' => $user->profile,
            ],
        ]);
    }

    /**
     * Logout the current authenticated session.
     *
     * Revokes the Redis session and invalidates
     * the current JWT access token.
     *
     * @return JsonResponse
     */
    public function logout(): JsonResponse
    {
        $payload = JWTAuth::parseToken()->getPayload();
        $sessionId = $payload->get('sid');

        if (!$sessionId) {
            return response()->json([
                'success' => false,
                'message' => 'Session ID tidak ditemukan.',
            ], 401);
        }

        $this->sessions->revoke($sessionId);

        JWTAuth::invalidate();

        return response()->json([
            'success' => true,
            'message' => 'Logout berhasil.',
        ]);
    }

    /**
     * Logout the user from all active devices.
     *
     * Revokes every Redis session associated with the user
     * and invalidates the current JWT access token.
     *
     * @return JsonResponse
     */
    public function logoutAll(): JsonResponse
    {
        /** @var User|null $user */
        $user = JWTAuth::parseToken()->authenticate();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User tidak ditemukan.',
            ], 401);
        }

        $this->sessions->revokeAll((string) $user->id);

        JWTAuth::invalidate();

        return response()->json([
            'success' => true,
            'message' => 'Seluruh session berhasil dicabut.',
        ]);
    }

    /**
     * Collect client device information for session tracking.
     *
     * Stores the device name, client IP address,
     * and user agent as Redis session metadata.
     *
     * @param Request $request
     * @param array $data
     * @return array
     */
    private function deviceMetadata(
        Request $request,
        array $data
    ): array {
        return [
            'device_name' => $data['device_name'] ?? 'Unknown Device',
            'ip_address' => $request->ip(),
            'user_agent' => $request->userAgent(),
        ];
    }
}