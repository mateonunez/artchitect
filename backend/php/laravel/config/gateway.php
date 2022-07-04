<?php

use Illuminate\Support\Facades\Facade;

return [

    /*
    |--------------------------------------------------------------------------
    | Kong Gateway Endpoint
    |--------------------------------------------------------------------------
    |
    | This value is the Kong Gateway endpoint. This value is used when we need
    | to send a request to the Kong Gateway or access to a microservice.
    |
    */

    'kong_endpoint' => env('KONG_GATEWAY_ENDPOINT', 'http://kong:8000/'),
];
