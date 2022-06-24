import { sendEmail } from './lib/mailgun';

const Mailman = async () => {
  console.log('Mailman is running');

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
};

Mailman();
