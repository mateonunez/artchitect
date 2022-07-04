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

        $kongEndpoint = config('gateway.kong_endpoint');
        $userLoggedInEnpoint = $kongEndpoint . '/users/logged-in';
        $userSendEmailEndpoint = $kongEndpoint . '/users/send-email';

        $user = $event->user->toArray();

        $payload = [
            'data' => $user,
            'event' => 'user-logged-in',
            'callbacks' => [
                'testing_callback' => [
                    'url' => $userLoggedInEnpoint,
                    'method' => 'POST',
                ],
                'mailman_callback' => [
                    'url' => $userSendEmailEndpoint,
                    'method' => 'POST',
                    'body' => [
                        'template' => 'default',
                        'to' => $user['email'],
                        'subject' => 'Recent Activity',
                        'props' => [
                            'title' => 'We noticed that you are logged in.',
                            'content' => 'We just wanted to welcome you and give you a big hug.',
                        ]
                    ]
                ],
            ],
        ];

        $message = $rabbitMQClient->produce(json_encode($payload));

        Log::info('Dispatching UserLoggedIn event to RabbitMQ: ' . json_encode($message));
    }
}
