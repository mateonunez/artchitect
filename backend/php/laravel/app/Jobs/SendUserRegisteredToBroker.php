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

        $user = $event->user->toArray();

        $payload = [
            'data' => $user,
            'event' => 'user-registered',
            'callbacks' => [
                'testing_callback' => [
                    'url' => 'http://balancer_nginx/users/registered', // ! Change this!
                    'method' => 'POST',
                ],
                'mailman_callback' => [
                    'url' => 'http://mailman:5555/send-email', // ! Change this!
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
