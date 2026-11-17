<?php

return [
    'session_driver' => env('AUTH_SESSION_DRIVER', 'redis'),

    'session_ttl' => (int) env(
        'AUTH_SESSION_TTL',
        2592000
    ),

    'refresh_ttl' => (int) env(
        'AUTH_REFRESH_TTL',
        2592000
    ),

    'access_token_ttl' => (int) env(
        'JWT_TTL',
        15
    ),
];