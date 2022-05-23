import client, { Channel, Connection, ConsumeMessage } from 'amqplib';
import dotenv from 'dotenv';
import reducer, { RouterProps } from './router/reducer';


export const connect = async (): Promise<Connection> => {
  dotenv.config();

  const host: string = process.env.RABBITMQ_HOST || 'architect_rabbitmq';
  const port: string = process.env.RABBITMQ_PORT || '5672';
  const user: string = process.env.RABBITMQ_USER || 'architect';
  const pass: string = process.env.RABBITMQ_PASS || 'architect';

  console.log(`[watchful ⚡️] Hi Architect, I'm connecting to the broker ${host}:${port}`);

  const connection: Connection = await client
    .connect(`amqp://${user}:${pass}@${host}:${port}`)
    .catch((err: any) => {
      console.error(`[watchful ⚡️] Error connecting to the broker ${err.message}`);

      throw err;
    });

  if (connection) {
    console.log(`[watchful ⚡️] Connected to the broker ${host}:${port}`);
  }

  return connection;
};

export const createChannel = async (connection: Connection): Promise<Channel> => {
  const channel: Channel = await connection.createChannel().catch((err: any) => {
    console.error(`[watchful ⚡️] Error creating the channel ${err.message}`);

    throw err;
  });

  return channel;
};

export const assertExchange = async (channel: Channel, exchange: string) => {
  await channel.assertExchange(exchange, 'direct').catch((err: any) => {
    console.error(`[watchful ⚡️] Error asserting the exchange ${err.message}`);

    throw err;
  });
};

export const assertQueue = async (channel: Channel, queue: string) => {
  await channel.assertQueue('architect-queue').catch((err: any) => {
    console.error(`[watchful ⚡️] Error asserting the queue ${err.message}`);

    throw err;
  });
};

export const consumer =
  (channel: Channel) =>
  async (message: ConsumeMessage | null): Promise<void> => {
    if (message) {
      const routingKey: string = message.fields.routingKey;
      const rest: RouterProps = {
        broker: {
          channel,
          message
        }
      };

      await reducer(routingKey, rest);
    }
  };

export const watchful = async (): Promise<void> => {
  const connection: Connection = await connect();
  const channel: Channel = await createChannel(connection);

  const exchangeName: string = 'architect-exchange';
  const queueName: string = 'architect-queue';

  await assertExchange(channel, exchangeName);
  await assertQueue(channel, queueName);

  await channel.consume(queueName, consumer(channel));
};

watchful();
