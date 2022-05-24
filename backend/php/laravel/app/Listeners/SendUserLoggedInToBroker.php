<?php

namespace App\Listeners;

use App\Core\Brokers\RabbitMQ;
use App\Events\UserLoggedIn;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Support\Facades\Log;

class SendUserLoggedInToBroker
{
    /**
     * Create the event listener.
     *
     * @return void
     */
    public function __construct()
    {
        //
    }

    /**
     * Handle the event.
     *
     * @param  \App\Events\UserLoggedIn  $event
     * @return void
     */
    public function handle(UserLoggedIn $event)
    {
        $rabbitMQClient = new RabbitMQ(default: true);
        $rabbitMQClient->bind(
            'architect-exchange',
            'architect-queue',
            'yellow'
        );

        $user = $event->user->toArray();

        $payload = [
            'data' => $user,
            'event' => 'user-logged-in',
            'callbacks' => [
                'testing_callback' => [
                    'url' => 'http://architect_nginx_balancer/users/logged-in',
                    'method' => 'POST',
                ],
            ],
        ];

        $message = $rabbitMQClient->produce(json_encode($payload));

        Log::info('Dispatching UserLoggedIn event to RabbitMQ: ' . json_encode($message));
    }
}
