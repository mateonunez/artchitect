import bodyParser from 'body-parser';
import dotenv from 'dotenv';
import express from 'express';

dotenv.config();

const { BALANCER_HOST, BALANCER_PORT } = process.env;

const server = () => {
  const app = express();

  app.use(bodyParser.json());
  app.use(bodyParser.urlencoded({ extended: true }));

  app.post('/users/logged-in', (req, res) => {
    console.log('[ balancer (JS) ⚖️ ] Called API: /users/logged-in');

    const { id, name, email } = req.body;

    res.send({
      loggedIn: true,
      user: {
        id,
        name,
        email
      },
      appId: 'javascript-balancer'
    });
  });

  app.listen(BALANCER_PORT, BALANCER_HOST, () => {
    console.log(`[ balancer (JS) ⚖️ ] Server is listening on ${BALANCER_HOST}:${BALANCER_PORT}`);
  });
};

server();
