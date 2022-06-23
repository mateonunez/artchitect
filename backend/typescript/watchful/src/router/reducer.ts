import { Channel, ConsumeMessage } from 'amqplib';
import { colorful, yellow } from '.';

export type RouterOptionsProps = {
  priority?: number;
};

export type RouterBrokerProps = {
  channel: Channel;
  message: ConsumeMessage;
};

export type RouterProps = {
  broker: RouterBrokerProps;
  options?: RouterOptionsProps;
};

export default async function reducer(routingKey: string, rest: RouterProps): Promise<void> {
  switch (routingKey) {
    case 'yellow':
      console.log(
        `[ watchful 🟨 ] Received message to the yellow queue, forwarding to the yellow handler`
      );

      return await yellow(rest);
    default:
      console.log(
        `[ watchful 🌈 ] Received message to the unknown queue or router-key, forwarding to the default handler 🌈`
      );

      return await colorful(rest);
  }
}
