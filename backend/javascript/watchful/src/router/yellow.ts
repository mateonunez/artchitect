import axios, { AxiosResponse } from 'axios';
import { UserLoggedIn } from '../lib/yellow/types/user-logged-in';
import { RouterProps } from './reducer';

const handler = async (props: RouterProps): Promise<void> => {
  const { broker, options } = props;

  const { channel, message } = broker;

  const userLoggedInEvent: UserLoggedIn = JSON.parse(message.content.toString());

  console.log(`[ yellow router 🟨 ] Received event ${userLoggedInEvent.event}`);

  const { event, data, callbacks } = userLoggedInEvent;

  await Promise.all(
    Object.keys(callbacks).map(async (callbackKey: any) => {
      const callback = callbacks[callbackKey];

      console.log(`[ yellow router 🟨 ] Executing callback ${callbackKey} [${callback.url}]`);

      const response: AxiosResponse = await axios({
        url: callback.url,
        method: callback.method,
        headers: callback.headers,
        data: {
          ...callback.body,
          ...data
        }
      })
        .then((res: AxiosResponse) => res)
        .catch((error: any) => {
          console.error(
            `[ yellow router 🟨 ] Error executing callback ${callbackKey} [${
              callback.url
            }], response with code ${
              error.response.status
            } and the following data: ${JSON.stringify(error.response.data)}`
          );

          channel.nack(message, false, false);

          return new Promise((resolve, reject) => reject(error));
        });

      console.log(
        `[ yellow router 🟨 ] Executed callback ${callbackKey}, response with code ${
          response.status
        } and the following data: ${JSON.stringify(response.data)}`
      );
    })
  );

  console.log(`[ yellow router 🟨 ] ${Object.keys(callbacks).length} callbacks executed`);

  channel.ack(message);

  return new Promise(resolve => resolve());
};

export default handler;
