import client, { Channel, Connection, ConsumeMessage } from 'amqplib';
import dotenv from 'dotenv';

import reducer from './router/reducer';

dotenv.config();

const RABBITMQ_HOST: string = process.env.RABBITMQ_HOST || 'architect_rabbitmq';
const RABBITMQ_PORT: string = process.env.RABBITMQ_PORT || '5672';
const RABBITMQ_USER: string = process.env.RABBITMQ_USER || 'architect';
const RABBITMQ_PASS: string = process.env.RABBITMQ_PASS || 'architect';

const watchful = async (): Promise<void> => {
  console.log(`[watchful ⚡️] Connecting to the broker ${RABBITMQ_HOST}:${RABBITMQ_PORT}`);

  const connection: Connection = await client
    .connect(`amqp://${RABBITMQ_USER}:${RABBITMQ_PASS}@${RABBITMQ_HOST}:${RABBITMQ_PORT}`)
    .catch((err: any) => {
      console.error(`[watchful ⚡️] Error connecting to the broker ${err.message}`);

      throw err;
    });

  if (connection) {
    console.log(`[watchful ⚡️] Connected to the broker ${RABBITMQ_HOST}:${RABBITMQ_PORT}`);
  }

  const channel: Channel = await connection.createChannel().catch((err: any) => {
    console.error(`[watchful ⚡️] Error creating the channel ${err.message}`);

    throw err;
  });

  await channel
    .assertExchange('architect-exchange', 'direct', {
      durable: true
    })
    .catch((err: any) => {
      console.error(`[watchful ⚡️] Error asserting the exchange ${err.message}`);

      throw err;
    });

  await channel.assertQueue('architect-queue').catch((err: any) => {
    console.error(`[watchful ⚡️] Error asserting the queue ${err.message}`);

    throw err;
  });

  const consumer =
    (channel: Channel) =>
    (message: ConsumeMessage | null): void => {
      if (message) {
        reducer(message.fields.routingKey, {
          broker: {
            channel,
            message
          }
        });

        channel.ack(message);
      }
    };

  await channel.consume('architect-queue', consumer(channel));
};

watchful();
