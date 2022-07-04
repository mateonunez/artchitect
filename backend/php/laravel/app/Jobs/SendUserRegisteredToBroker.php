<?php

namespace App\Jobs;

use App\Events\UserRegistered;
use Illuminate\Bus\Queueable;
use App\Core\Brokers\RabbitMQ;
use Illuminate\Support\Facades\Log;
use Illuminate\Queue\SerializesModels;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;

class SendUserRegisteredToBroker implements ShouldQueue
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
    public function handle(UserRegistered $event)
    {
        $rabbitMQClient = new RabbitMQ(default: true);
        $rabbitMQClient->bind(
            'architect-exchange',
            'architect-queue',
            'yellow'
        );

        $kongEndpoint = config('gateway.kong_endpoint');
        $userRegisteredEnpoint = $kongEndpoint . '/users/registered';
        $userSendEmailEndpoint = $kongEndpoint . '/users/send-email';

        $user = $event->user->toArray();

        $payload = [
            'data' => $user,
            'event' => 'user-registered',
            'callbacks' => [
                'testing_callback' => [
                    'url' => $userRegisteredEnpoint,
                    'method' => 'POST',
                ],
                'mailman_callback' => [
                    'url' => $userSendEmailEndpoint,
                    'method' => 'POST',
                    'body' => [
                        'template' => 'user-registered',
                        'to' => $user['email'],
                        'subject' => 'Welcome Dear Architect!',
                        'props' => [
                            'title' => 'Hi there, welcome to Home',
                            'content' => 'You have successfully registered to Home!',
                        ]
                    ]
                ],
            ],
        ];

        $message = $rabbitMQClient->produce(json_encode($payload));

        Log::info('Dispatching UserRegistered event to RabbitMQ: ' . json_encode($message));
    }
}
