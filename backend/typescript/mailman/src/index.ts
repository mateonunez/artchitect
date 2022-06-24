import { fastify } from 'fastify';
import pino from 'pino';
import { sendEmail } from './lib/mailgun';
/**
 * Declaring routes
 */
const server = fastify({
  logger: pino({ level: 'info' })
});

const Mailman = async () => {
  console.log('Mailman is running');

  server.post('/send-email', async (request, response) => {
    server.log.info('Received a request to send an email');

    await sendEmail({
      to: 'mateonunez95@gmail.com',
      subject: 'Test',
      props: {
        title: 'Test',
        content: 'Test'
      }
    }).catch(error => {
      console.error(error);
    });

    response.send({
      message: 'Email sent'
    });
  });

  try {
    await server.listen(3000);
  } catch (err) {
    server.log.error(err);
    process.exit(1);
  }
};

Mailman();
