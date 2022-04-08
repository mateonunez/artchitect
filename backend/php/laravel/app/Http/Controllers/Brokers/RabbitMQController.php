<?php

/**
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

class RabbitMQController extends Controller
{
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

        $connection = new AMQPStreamConnection(
            'architect_rabbitmq',
            5672,
            'architect',
            'architect'
        );

        $channel = $connection->channel();

        $message = new AMQPMessage($request->get('message'));

        $channel->basic_publish($message, 'architect-exchange', 'red');

        return $this->sendResponse(
            data: [
                'message' => json_encode($message)
            ],
            message: 'Message sent to RabbitMQ'
        );
    }
}
