import { UserLoggedIn } from '../lib/yellow/types/user-logged-in';
import { RouterProps } from './reducer';

const handler = async (args: RouterProps): Promise<void> => {
  const { broker, options } = args;

  const { channel, message } = broker;

  console.table(message.properties.headers);

  const userLoggedInEvent: UserLoggedIn = JSON.parse(message.content.toString());

  console.log(`[ yellow router 🟨 ] Received event ${userLoggedInEvent.event}`);

  channel.ack(message);

  return new Promise(resolve => resolve());
};

export default handler;