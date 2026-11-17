
<?php

use App\Http\Controllers\Api\V1\Auth\AuthController;
use App\Http\Controllers\Api\V1\Profile\ProfileController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| API routes for Marketplace Katering.
| All routes are prefixed with /api automatically.
|
*/

Route::prefix('v1')->group(function () {

    /*
    |--------------------------------------------------------------------------
    | Authentication Routes
    |--------------------------------------------------------------------------
    */

    Route::prefix('auth')->group(function () {

        // Public routes
        Route::middleware('throttle:5,1')->group(function () {
            Route::post('/register', [AuthController::class, 'register']);
            Route::post('/login', [AuthController::class, 'login']);
        });

        // Protected routes
        Route::middleware(['auth:api', 'active.session'])->group(function () {
            Route::get('/me', [AuthController::class, 'me']);
            Route::post('/logout', [AuthController::class, 'logout']);
            Route::post('/logout-all', [AuthController::class, 'logoutAll']);
        });
    });

    /*
    |--------------------------------------------------------------------------
    | Profile Routes
    |--------------------------------------------------------------------------
    */

    Route::prefix('profile')
        ->middleware(['auth:api', 'active.session'])
        ->controller(ProfileController::class)
        ->group(function () {
            Route::get('/', 'show');
            Route::patch('/', 'update');
        });

});
