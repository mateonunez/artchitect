<?php

/**
 * This is not the correct implementation to produce and consume messages.
 * This is just a snippet to show how to use RabbitMQ with Laravel.
 *
 * Used the rainbow colors to generate the routing keys
 *
 * 1) Red
 * 2) Orange
 * 3) Yellow
 * 4) Green
 * 5) Blue
 * 6) Indigo
 * 7) Violet
 */

namespace App\Http\Controllers\Brokers;

use App\Lib\Message;
use Illuminate\Http\Request;
use App\Core\Brokers\RabbitMQ;
use Illuminate\Http\JsonResponse;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;

class RabbitMQController extends Controller
{
    /** @var \App\Core\Brokers\RabbitMQ */
    protected $rabbitMQClient;

    /**
     * @return void
     */
    public function __construct()
    {
        $this->rabbitMQClient = new RabbitMQ(default: true);

        $this->rabbitMQClient->bind(
            'architect-exchange',
            'architect-queue',
            'red'
        );
    }

    /**
     * Produces (sends) a message to RabbitMQ
     *
     * @param \Illuminate\Http\Request $request
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function produce(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'message' => 'required|string'
        ]);

        if ($validator->fails()) {
            return $this->sendError(
                error: Message::BAD_REQUEST,
                errorMessages: $validator->errors()->all(),
                statusCode: 400
            );
        }

        $data = [
            'message' => $request->get('message')
        ];

        $message = $this->rabbitMQClient->produce(json_encode($data));

        return $this->sendResponse(
            data: [
                'message' => $message
            ],
            message: 'Message sent to RabbitMQ'
        );
    }

    /**
     * Consumes (receives) a message from RabbitMQ
     *
     * @param \Illuminate\Http\Request $request
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function consume(Request $request): JsonResponse
    {
        $message = $this->rabbitMQClient->consume();

        if (!$message) {
            return $this->sendError(
                error: Message::NO_DATA,
                errorMessages: [],
                statusCode: JsonResponse::HTTP_OK
            );
        }

        return $this->sendResponse(
            data: [
                'message' => json_encode($message)
            ],
            message: 'Message consumed from RabbitMQ'
        );
    }
}
