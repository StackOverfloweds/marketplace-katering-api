<?php

namespace App\Http\Middleware;

use App\Models\User;
use App\Services\Auth\AuthSessionService;
use Closure;
use Illuminate\Http\Request;
use PHPOpenSourceSaver\JWTAuth\Facades\JWTAuth;
use Symfony\Component\HttpFoundation\Response;
use Throwable;

/**
 * Validate the active Redis session of an authenticated user.
 *
 * Ensures that each JWT access token belongs to an existing
 * and active Redis session before allowing access to protected routes.
 */
class EnsureActiveSession
{
    /**
     * Initialize middleware dependencies.
     *
     * @param AuthSessionService $sessions
     */
    public function __construct(
        private AuthSessionService $sessions
    ) {}

    /**
     * Handle an incoming HTTP request.
     *
     * Validates the JWT payload, checks the authenticated user
     * status, and verifies that the associated Redis session
     * still exists and is active.
     *
     * Requests are rejected when the token is invalid,
     * the account is inactive, or Redis cannot be verified.
     *
     * @param Request $request Incoming HTTP request
     * @param Closure $next Next middleware or request handler
     * @return Response HTTP response
     */
    public function handle(
        Request $request,
        Closure $next
    ): Response {
        try {
            $payload = JWTAuth::parseToken()->getPayload();

            /** @var User|null $user */
            $user = JWTAuth::authenticate();

            if (!$user || !$user->is_active) {
                return response()->json([
                    'success' => false,
                    'message' => 'Akun tidak aktif atau tidak terautentikasi.',
                ], 401);
            }

            $sessionId = $payload->get('sid');

            if (
                !$sessionId ||
                !$this->sessions->isActive($sessionId)
            ) {
                return response()->json([
                    'success' => false,
                    'message' => 'Session tidak ditemukan atau sudah berakhir.',
                ], 401);
            }

            return $next($request);

        } catch (Throwable $exception) {
            report($exception);

            return response()->json([
                'success' => false,
                'message' => 'Layanan autentikasi sementara tidak tersedia.',
            ], 503);
        }
    }
}
