<?php

namespace App\Interfaces;

interface BrokerInterface
{
    /**
     * Sends a message to the broker
     *
     * @param string $message
     *
     * @return mixed
     */
    public function produce(string $message);

    /**
     * Consumes a message from the broker
     *
     * @return mixed
     */
    public function consume();
}
