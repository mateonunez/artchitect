<?php

namespace App\Jobs;

use App\Events\UserLoggedIn;
use Illuminate\Bus\Queueable;
use App\Core\Brokers\RabbitMQ;
use Illuminate\Support\Facades\Log;
use Illuminate\Queue\SerializesModels;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Contracts\Queue\ShouldBeUnique;

class SendUserLoggedInToBroker implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct()
    {
        //
    }

    /**
     * Execute the job.
     *
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
