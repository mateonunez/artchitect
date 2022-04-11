import dotenv from 'dotenv';
import client, { Channel, Connection, ConsumeMessage } from 'amqplib';

(async () => {
  dotenv.config();

  const { RABBITMQ_HOST, RABBITMQ_PORT, RABBITMQ_USER, RABBITMQ_PASS } = process.env;

  const connection: Connection = await client.connect(
    `amqp://${RABBITMQ_USER}:${RABBITMQ_PASS}@${RABBITMQ_HOST}:${RABBITMQ_PORT}`
  );

  console.log(`amqp://${RABBITMQ_USER}:${RABBITMQ_PASS}@${RABBITMQ_HOST}:${RABBITMQ_PORT}`);

  const channel: Channel = await connection.createChannel();

  await channel.assertExchange('architect-exchange', 'direct', {
    durable: true
  });
  await channel.assertQueue('architect-queue');

  const consumer =
    (channel: Channel) =>
    (message: ConsumeMessage | null): void => {
      if (message) {
        console.log('Message received: ', message.content.toString());

        channel.ack(message);
      }
    };

  await channel.consume('architect-queue', consumer(channel));
})();
