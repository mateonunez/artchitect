import dotenv from 'dotenv';
import { fastify } from 'fastify';
import pino from 'pino';
import { sendEmail } from './lib/mailgun';

export type SendEmailProps = {
  to: string;
  subject: string;
  template: string;
  props?: any;
};
/**
 * Declaring routes
 */
const server = fastify({
  logger: pino({ level: 'info' })
});

const Mailman = async () => {
  dotenv.config();

  const host: string = process.env.HOST || '0.0.0.0';
  const port: number = parseInt(<string>process.env.PORT, 10) || 5555;

  server.post('/send-email', async (request, response) => {
    const { to, subject, template, props } = request.body as SendEmailProps;

    if (!to || !subject || !template) {
      server.log.error(`[Mailman] Missing parameters: ${to}, ${subject}, ${template}`);

      return response.status(400).send({
        error: 'Missing parameters'
      });
    }

    await sendEmail({
      to,
      subject,
      template,
      props
    }).catch(error => {
      console.error(error);
    });

    response.send({
      message: 'Email sent'
    });
  });

  try {
    await server.listen(port, host);
  } catch (err) {
    server.log.error(err);
    process.exit(1);
  }
};

Mailman();
