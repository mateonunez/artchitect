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
use Illuminate\Http\JsonResponse;
use PhpAmqpLib\Message\AMQPMessage;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;
use PhpAmqpLib\Connection\AMQPStreamConnection;
use PhpAmqpLib\Exchange\AMQPExchangeType;

class RabbitMQController extends Controller
{
    /** @var \PhpAmqpLib\Connection\AMQPStreamConnection */
    protected $connection;

    /** @var \PhpAmqpLib\Channel\AMQPChannel */
    protected $channel;

    /**
     * @return void
     */
    public function __construct()
    {
        $this->connection = new AMQPStreamConnection(
            'architect_rabbitmq',
            5672,
            'architect',
            'architect'
        );

        $this->channel = $this->connection->channel();

        $this->channel->queue_declare('architect-queue', false, true, false, false);
        $this->channel->exchange_declare('architect-exchange', AMQPExchangeType::DIRECT, false, true, false);
        $this->channel->queue_bind('architect-queue', 'architect-exchange', 'red');
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

        $message = new AMQPMessage($request->get('message'));

        $this->channel->basic_publish($message, 'architect-exchange', 'red');

        return $this->sendResponse(
            data: [
                'message' => json_encode($message)
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
        $message = $this->channel->basic_get('architect-queue');

        if (!$message) {
            return $this->sendError(
                error: Message::NO_DATA,
                errorMessages: [],
                statusCode: JsonResponse::HTTP_OK
            );
        }

        $message->ack();


        return $this->sendResponse(
            data: [
                'message' => json_encode($message)
            ],
            message: 'Message consumed from RabbitMQ'
        );
    }
}
