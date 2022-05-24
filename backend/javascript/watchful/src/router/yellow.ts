import axios from 'axios';
import { UserLoggedIn } from '../lib/yellow/types/user-logged-in';
import { RouterProps } from './reducer';

const handler = async (args: RouterProps): Promise<void> => {
  const { broker, options } = args;

  const { channel, message } = broker;

  const userLoggedInEvent: UserLoggedIn = JSON.parse(message.content.toString());

  console.log(`[ yellow router 🟨 ] Received event ${userLoggedInEvent.event}`);

  const { event, data, callbacks } = userLoggedInEvent;

  await Promise.all(
    Object.keys(callbacks).map(async (callbackKey: any) => {
      const callback = callbacks[callbackKey];
      console.log(`[ yellow router 🟨 ] Executing callback ${callbackKey} [${callback.url}]`);

      return await axios({
        method: callback.method,
        url: callback.url,
        data: callback.body,
        headers: callback.headers
      });
    })
  );

  console.log(`[ yellow router 🟨 ] ${Object.keys(callbacks).length} callbacks executed`);

  channel.ack(message);

  return new Promise(resolve => resolve());
};

export default handler;
