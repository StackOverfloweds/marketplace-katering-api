
<?php

use App\Http\Controllers\Api\V1\Auth\AuthController;
use App\Http\Controllers\Api\V1\Category\CategoryController;
use App\Http\Controllers\Api\V1\Invoice\InvoiceController;
use App\Http\Controllers\Api\V1\Menu\MenuController;
use App\Http\Controllers\Api\V1\Merchant\MerchantController;
use App\Http\Controllers\Api\V1\Order\OrderController;
use App\Http\Controllers\Api\V1\Profile\ProfileController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {

    Route::get('/merchants', [MerchantController::class, 'index']);

        /*
        |--------------------------------------------------------------------------
        | Authentication Routes
        |--------------------------------------------------------------------------
        */

        Route::prefix('auth')->group(function () {

            Route::middleware('throttle:5,1')->group(function () {
                Route::post('/register', [AuthController::class, 'register']);
                Route::post('/login', [AuthController::class, 'login']);
            });

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

        /*
        |--------------------------------------------------------------------------
        | Public Menu Routes
        |--------------------------------------------------------------------------
        */

        Route::prefix('menus')
            ->controller(MenuController::class)
            ->group(function () {
                Route::get('/', 'index');
                Route::get('/{menu}', 'show');
            });

        /*
        |--------------------------------------------------------------------------
        | Merchant Menu Management
        |--------------------------------------------------------------------------
        */

        Route::prefix('menus')
            ->middleware(['auth:api', 'active.session'])
            ->controller(MenuController::class)
            ->group(function () {
                Route::post('/', 'store');
                Route::put('/{menu}', 'update');
                Route::patch('/{menu}', 'update');
                Route::delete('/{menu}', 'destroy');
            });

    
            /*
            |--------------------------------------------------------------------------
            | Category Routes
            |--------------------------------------------------------------------------
            */

            Route::prefix('categories')->group(function () {

            /*
            |--------------------------------------------------------------------------
            | Merchant Category Management
            |--------------------------------------------------------------------------
            */

            Route::middleware(['auth:api', 'active.session'])->group(function () {

                // Static route harus didaftarkan sebelum dynamic route
                Route::get('/my', [CategoryController::class, 'myCategories']);

                Route::post('/', [CategoryController::class, 'store']);

                Route::patch('/{category}', [CategoryController::class, 'update'])
                    ->whereUuid('category');

                Route::delete('/{category}', [CategoryController::class, 'destroy'])
                    ->whereUuid('category');
            });

            /*
            |--------------------------------------------------------------------------
            | Public Category Routes
            |--------------------------------------------------------------------------
            */

            Route::get('/', [CategoryController::class, 'index']);

            Route::get('/{category}', [CategoryController::class, 'show'])
                ->whereUuid('category');
        });


            /*
            |--------------------------------------------------------------------------
            | Order Routes
            |--------------------------------------------------------------------------
            */

            Route::prefix('orders')
            ->middleware(['auth:api', 'active.session'])
            ->controller(OrderController::class)
            ->group(function () {

                // Customer and merchant
                Route::get('/', 'index');
                Route::get('/{order}', 'show')
                    ->whereUuid('order');

                // Customer
                Route::post('/', 'store');
                Route::patch('/{order}/cancel', 'cancel')
                    ->whereUuid('order');

                // Merchant
                Route::patch('/{order}/status', 'updateStatus')
                    ->whereUuid('order');
            });

            /*
            |--------------------------------------------------------------------------
            | Invoice Routes
            |--------------------------------------------------------------------------
            */
            Route::prefix('invoices')
            ->middleware(['auth:api', 'active.session'])
            ->controller(InvoiceController::class)
            ->group(function () {
                Route::get('/', 'index');
                Route::get('/{invoice}', 'show')->whereUuid('invoice');
            });
});
