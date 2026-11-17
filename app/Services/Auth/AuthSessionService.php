<?php

namespace App\Services\Auth;

use App\Models\User;
use Illuminate\Support\Facades\Redis;
use Illuminate\Support\Str;

/**
 * Manage authentication sessions using Redis.
 *
 * Responsible for creating, retrieving, validating,
 * and revoking user authentication sessions.
 * Refresh tokens are stored as SHA-256 hashes.
 */
class AuthSessionService
{
    /**
     * Generate the Redis key for a specific session.
     *
     * @param string $sessionId Session UUID
     * @return string Redis session key
     */
    private function sessionKey(string $sessionId): string
    {
        return "auth:session:{$sessionId}";
    }

    /**
     * Generate the Redis key containing a user's session index.
     *
     * @param string $userId User UUID
     * @return string Redis user session index key
     */
    private function userSessionsKey(string $userId): string
    {
        return "auth:user_sessions:{$userId}";
    }

    /**
     * Generate the Redis key for a hashed refresh token.
     *
     * @param string $refreshHash SHA-256 refresh token hash
     * @return string Redis refresh token key
     */
    private function refreshKey(string $refreshHash): string
    {
        return "auth:refresh:{$refreshHash}";
    }

    /**
     * Create a new authentication session for a user.
     *
     * Generates a unique session UUID and a cryptographically
     * random refresh token. Stores session metadata and the
     * hashed refresh token in Redis with an expiration time.
     *
     * @param User $user Authenticated user
     * @param array $metadata Client device metadata
     * @return array Session ID, plaintext refresh token, and TTL
     */
    public function create(User $user, array $metadata = []): array
    {
        $sessionId = (string) Str::uuid7();
        $refreshToken = Str::random(96);
        $refreshHash = hash('sha256', $refreshToken);

        $ttl = (int) config(
            'authentication.session_ttl',
            2592000
        );

        $session = [
            'id' => $sessionId,
            'user_id' => (string) $user->id,
            'device_name' => $metadata['device_name'] ?? 'Unknown Device',
            'ip_address' => $metadata['ip_address'] ?? null,
            'user_agent' => $metadata['user_agent'] ?? null,
            'refresh_hash' => $refreshHash,
            'created_at' => now()->toIso8601String(),
            'last_activity_at' => now()->toIso8601String(),
        ];

        Redis::setex(
            $this->sessionKey($sessionId),
            $ttl,
            json_encode($session, JSON_THROW_ON_ERROR)
        );

        Redis::sadd(
            $this->userSessionsKey((string) $user->id),
            $sessionId
        );

        Redis::expire(
            $this->userSessionsKey((string) $user->id),
            $ttl
        );

        Redis::setex(
            $this->refreshKey($refreshHash),
            $ttl,
            $sessionId
        );

        return [
            'session_id' => $sessionId,
            'refresh_token' => $refreshToken,
            'expires_in' => $ttl,
        ];
    }

    /**
     * Determine whether an authentication session is active.
     *
     * @param string $sessionId Session UUID
     * @return bool True when the session exists in Redis
     */
    public function isActive(string $sessionId): bool
    {
        return (bool) Redis::exists(
            $this->sessionKey($sessionId)
        );
    }

    /**
     * Retrieve authentication session metadata from Redis.
     *
     * @param string $sessionId Session UUID
     * @return array|null Session metadata or null when not found
     */
    public function getSession(string $sessionId): ?array
    {
        $data = Redis::get($this->sessionKey($sessionId));

        return $data ? json_decode($data, true) : null;
    }

    /**
     * Revoke a specific authentication session.
     *
     * Deletes the session and associated refresh token,
     * then removes the session ID from the user's session index.
     *
     * @param string $sessionId Session UUID to revoke
     * @return void
     */
    public function revoke(string $sessionId): void
    {
        $session = $this->getSession($sessionId);

        if (!$session) {
            return;
        }

        Redis::del(
            $this->sessionKey($sessionId),
            $this->refreshKey($session['refresh_hash'])
        );

        Redis::srem(
            $this->userSessionsKey($session['user_id']),
            $sessionId
        );
    }

    /**
     * Revoke all active sessions belonging to a user.
     *
     * Retrieves all registered session IDs and revokes
     * each associated session and refresh token.
     *
     * @param string $userId User UUID
     * @return void
     */
    public function revokeAll(string $userId): void
    {
        $sessionIds = Redis::smembers(
            $this->userSessionsKey($userId)
        );

        foreach ($sessionIds as $sessionId) {
            $this->revoke($sessionId);
        }

        Redis::del($this->userSessionsKey($userId));
    }
}
