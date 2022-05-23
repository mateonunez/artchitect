import { RouterProps } from './reducer';

const handler = async (args: RouterProps): Promise<void> => {
  const { broker, options } = args;
  const { channel, message } = broker;

  console.log(
    `[ colorful router 🌈 ] Received message on ${
      broker.message.fields.routingKey
    } router key: ${broker.message.content.toString()}`
  );

  channel.ack(message);

  return new Promise(resolve => resolve());
};

export default handler;
