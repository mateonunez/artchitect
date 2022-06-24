import dotenv from 'dotenv';
import FormData from 'form-data';
import Mailgun from 'mailgun.js';
import Client from 'mailgun.js/client';
import ReactDOMServer from 'react-dom/server';
import { DefaultTemplate, UserRegisteredTemplate } from '../templates';

export const from: string = 'No-Reply - Architect Mailman <no-reply@architect.com>';

export const templates = {
  default: DefaultTemplate,
  'user-registered': UserRegisteredTemplate
} as any;

export const initClient = (): Client => {
  dotenv.config();

  const url: string = process.env.MAILGUN_API_URL || 'https://api.mailgun.net/';
  const username: string = process.env.MAILGUN_USERNAME || 'api';
  const key: string = process.env.MAILGUN_API_KEY || 'api-key';

  const mailgun = new Mailgun(FormData);

  const client = mailgun.client({
    username,
    key,
    url
  });

  return client;
};

export const sendEmail = async ({
  to,
  subject,
  template = 'default',
  props = {}
}: {
  to: string;
  subject: string;
  template?: string;
  props?: any;
}): Promise<boolean> => {
  dotenv.config();
  const client: Client = initClient();

  const domain: string = process.env.MAILGUN_DOMAIN || 'architect.com';

  try {
    const templateWillUse = templates.hasOwnProperty(template)
      ? templates[template]
      : templates.default;

    const contentString = ReactDOMServer.renderToStaticMarkup(templateWillUse(props));

    console.log(contentString, props);

    await client.messages.create(domain, {
      from,
      to,
      subject,
      html: contentString
    });
  } catch (error) {
    throw error;
  }

  return true;
};
