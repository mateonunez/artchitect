/** @type {import('next').NextConfig} */
module.exports = {
  reactStrictMode: true,
  env: {
    BASE_URL: process.env.NEXT_PUBLIC_BASE_URL || 'http://localhost:3000',
    HOST: process.env.NEXT_PUBLIC_HOST || 'archifront_nginx',
    KONG_GATEWAY_ENDPOINT: process.env.NEXT_PUBLIC_KONG_GATEWAY_ENDPOINT || 'http://kong:8000',
    ARCHIFRONT_ENDPOINT: process.env.NEXT_PUBLIC_ARCHIFRONT_ENDPOINT || 'http://archifront_nginx:80'
  },
  webpackDevMiddleware: config => {
    config.watchOptions = {
      poll: 1000,
      aggregateTimeout: 300
    };
    return config;
  }
};
