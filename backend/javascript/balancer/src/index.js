const express = require('express');
const dotenv = require('dotenv');

const app = express();
dotenv.config();

const { BALANCER_HOST, BALANCER_PORT } = process.env;

app.get('/', (req, res) => {
  res.send(`Hello guest, I'm a Balancer running on the port: ${BALANCER_PORT}!`);
  console.log('Welcome to the JS Balancer. Time: ' + Date.now());
});

app.listen(BALANCER_PORT, BALANCER_HOST, () => {
  console.log(`Starting Balancer at ${BALANCER_HOST}:${BALANCER_PORT}`);
});
