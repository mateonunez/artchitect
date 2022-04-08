<?php

namespace App\Core\Brokers;

use App\Interfaces\BrokerInterface;
use PhpAmqpLib\Message\AMQPMessage;
use PhpAmqpLib\Exchange\AMQPExchangeType;
use PhpAmqpLib\Connection\AMQPStreamConnection;

class RabbitMQ implements BrokerInterface
{
    /** @var \PhpAmqpLib\Connection\AMQPStreamConnection */
    protected $connection;

    /** @var \PhpAmqpLib\Channel\AMQPChannel */
    protected $channel;

    /** @var string */
    protected $host;

    /** @var int */
    protected $port;

    /** @var string */
    protected $user;

    /** @var string */
    protected $password;

    /** @var string */
    protected $exchange;

    /** @var string */
    protected $queue;

    /** @var string */
    protected $routingKey;

    /**
     * Creates the connection and initialize the channel
     *
     * @return void
     */
    public function __construct(
        string $host,
        int $port,
        string $user,
        string $password,
    ) {
        $this->host = $host;
        $this->port = $port;
        $this->user = $user;
        $this->password = $password;

        $this->connection = new AMQPStreamConnection(
            $this->host,
            $this->port,
            $this->user,
            $this->password
        );

        $this->channel = $this->connection->channel();
    }

    /**
     * Bind the connection bridge from the exchange to the queue via the rountingKey
     *
     * @param string $exchange
     * @param string $queue
     * @param string $routingKey
     *
     * @return void
     */
    public function bind(string $exchange, string $queue, string $routingKey)
    {
        $this->exchange = $exchange;
        $this->queue = $queue;
        $this->routingKey = $routingKey;

        $this->channel->exchange_declare($this->exchange, AMQPExchangeType::DIRECT, false, true, false);
        $this->channel->queue_declare($this->queue, false, true, false, false);
        $this->channel->queue_bind($this->queue, $this->exchange, $this->routingKey);
    }

    /**
     * Produces a message to the broker
     *
     * @param string $message
     *
     * @return \PhpAmqpLib\Message\AMQPMessage
     */
    public function produce(string $message)
    {
        $message = new AMQPMessage($message);

        $this->channel->basic_publish($message, $this->exchange, $this->routingKey);

        return $message;
    }

    /**
     * Consumes a message from the broker
     *
     * @return \PhpAmqpLib\Message\AMQPMessage|null
     */
    public function consume()
    {
        $message = $this->channel->basic_get($this->queue);

        if (!$message) {
            return null;
        }

        $message->ack();

        return $message;
    }
}
