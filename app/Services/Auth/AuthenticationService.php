<?php

namespace App\Services\Auth;

use App\Models\User;
use App\Models\User as ModelsUser;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use PHPOpenSourceSaver\JWTAuth\Facades\JWTAuth;

/**
 * Handle user authentication and account registration.
 *
 * Responsible for registering new users, validating login
 * credentials, and issuing JWT access and refresh tokens.
 */
class AuthenticationService
{
    /**
     * Initialize authentication service dependencies.
     *
     * @param AuthSessionService $sessions
     */
    public function __construct(
        private AuthSessionService $sessions
    ) {}

    /**
     * Register a new user account and create its profile.
     *
     * Creates the user and profile within a database transaction.
     * After successful registration, creates a Redis session
     * and generates authentication tokens.
     *
     * @param array $data Validated registration data
     * @param array $metadata Client device metadata
     * @return array Authentication result containing user and tokens
     */
    public function register(array $data, array $metadata = []): array
    {
        return DB::transaction(function () use ($data, $metadata) {
            $user = ModelsUser::create([
                'username' => $data['username'],
                'password' => $data['password'],
                'role' => $data['role'],
                'is_active' => true,
            ]);

            $user->profile()->create([
                'full_name' => $data['full_name'],
                'email' => $data['email'],
                'phone' => $data['phone'],
                'company_name' => $data['company_name'] ?? null,
                'contact_person' => $data['contact_person'] ?? null,
                'address' => $data['address'] ?? null,
                'city' => $data['city'] ?? null,
            ]);

            return $this->issueTokens($user, $metadata);
        });
    }

    /**
     * Authenticate a user using username and password.
     *
     * Validates the supplied credentials and checks whether
     * the user account is active before issuing authentication tokens.
     *
     * @param array $credentials User login credentials
     * @param array $metadata Client device metadata
     * @return array Authentication result containing user and tokens
     *
     * @throws ValidationException When credentials are invalid
     * or the user account is inactive
     */
    public function login(array $credentials, array $metadata = []): array
    {
        $user = User::where('username', $credentials['username'])->first();

        if (
            !$user ||
            !Hash::check($credentials['password'], $user->password)
        ) {
            throw ValidationException::withMessages([
                'credentials' => ['Username atau password salah.'],
            ]);
        }

        if (!$user->is_active) {
            throw ValidationException::withMessages([
                'credentials' => ['Akun sedang dinonaktifkan.'],
            ]);
        }

        return $this->issueTokens($user, $metadata);
    }

    /**
     * Create an authentication session and issue JWT tokens.
     *
     * Creates a new Redis session for the authenticated user,
     * generates an access token with session and role claims,
     * and returns the corresponding refresh token.
     *
     * @param User $user Authenticated user model
     * @param array $metadata Client device metadata
     * @return array Authentication tokens and session information
     */
    private function issueTokens(User $user, array $metadata): array
    {
        $session = $this->sessions->create($user, $metadata);

        JWTAuth::factory()->setTTL(
            (int) config('authentication.access_token_ttl', 15)
        );

        $accessToken = JWTAuth::claims([
            'sid' => $session['session_id'],
            'role' => $user->role,
        ])->fromUser($user);

        return [
            'user' => $user->load('profile'),
            'access_token' => $accessToken,
            'refresh_token' => $session['refresh_token'],
            'token_type' => 'Bearer',
            'expires_in' => (int) config(
                'authentication.access_token_ttl',
                15
            ) * 60,
            'session_id' => $session['session_id'],
        ];
    }
}
