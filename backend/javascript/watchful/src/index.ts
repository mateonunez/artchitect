import client, { Channel, Connection, ConsumeMessage } from 'amqplib';

(async () => {
  const connection: Connection = await client.connect(
    'amqp://architect:architect@architect_rabbitmq:5672'
  );

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

console.log('hello');
