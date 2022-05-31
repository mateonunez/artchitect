/** @type {import('next').NextConfig} */
module.exports = {
  reactStrictMode: true,
  env: {
    BASE_URL: process.env.NEXT_PUBLIC_BASE_URL || 'http://localhost:3000',
    ARCHIFRONT_ENDPOINT: process.env.NEXT_PUBLIC_ARCHIFRONT_ENDPOINT || 'http://architect_nginx_laravel',
  },
  webpackDevMiddleware: config => {
    config.watchOptions = {
      poll: 1000,
      aggregateTimeout: 300
    };
    return config;
  }
};
