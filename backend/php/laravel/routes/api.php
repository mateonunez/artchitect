<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

/**
 * Authorization routes
 */
Route::group([
    'prefix' => 'auth',
    'as' => 'auth.'
], function () {
    Route::post('/login', [\App\Http\Controllers\AuthController::class, 'login']);
    Route::post('/register', [\App\Http\Controllers\AuthController::class, 'register']);
});

/**
 * Authenticated routes
 */
Route::group([
    'middleware' => 'auth:api',
    'as' => 'app.'
], function () {
    /**
     * Users
     */
    Route::group([
        'prefix' => 'users',
        'as' => 'users.'
    ], function () {
        // Profile
        Route::get('/me', [\App\Http\Controllers\UserController::class, 'me']);
    });

    /**
     * Brokers
     */
    Route::group([
        'prefix' => 'brokers',
        'as' => 'brokers.',
        'namespace' => 'Brokers'
    ], function () {
        /**
         * RabbitMQ
         */
        Route::group([
            'prefix' => 'rabbitmq',
            'as' => 'rabbitmq.'
        ], function () {
            Route::get('/consume', [\App\Http\Controllers\Brokers\RabbitMQController::class, 'consume']);
            Route::post('/produce', [\App\Http\Controllers\Brokers\RabbitMQController::class, 'produce']);
        });
    });

    /**
     * Admin routes
     */
    Route::group([
        'as' => 'resources.'
    ], function () {
        Route::apiResources([
            '/users' => \App\Http\Controllers\UserController::class,
        ]);
    });
});
