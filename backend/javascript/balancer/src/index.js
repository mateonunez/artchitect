const express = require('express');
const dotenv = require('dotenv');

const app = express();
dotenv.config();

const HOST = process.env.HOST || '127.0.0.1';
const PORT = process.env.PORT || 5010;

app.get('/', (req, res) => {
  res.send(`Hello guest, I'm a Balancer running on the port: ${port}!`);
});

app.use((req, res, next) => {
  console.log('Time: ', Date.now());
  next();
});

app.listen(PORT, HOST, () => {
  console.log(`Starting Balancer at ${PROXY_HOST}:${PROXY_PORT}`);
});
