/** @type {import('next').NextConfig} */
module.exports = {
  reactStrictMode: true,
  env: {
    BASE_URL: process.env.NEXT_PUBLIC_BASE_URL || 'http://localhost:3000',
    ARCHIVEL_ENDPOINT: process.env.NEXT_PUBLIC_ARCHIVEL_ENDPOINT || 'http://architect_nginx_laravel:8000',
    ARCHIFRONT_ENDPOINT: process.env.NEXT_PUBLIC_ARCHIFRONT_ENDPOINT || 'http://architect_nginx_archifront:80',
    ARCHIFRONT_AUTHENTICATION_ENDPOINT: process.env.NEXT_PUBLIC_ARCHIFRONT_AUTHENTICATION_ENDPOINT || 'http://architect_frontend_archifront_authentication:3010',
    ARCHIFRONT_HOMEPAGE_ENDPOINT: process.env.NEXT_PUBLIC_ARCHIFRONT_HOMEPAGE_ENDPOINT || 'http://architect_frontend_archifront_homepage:3030',
  },
  webpackDevMiddleware: config => {
    config.watchOptions = {
      poll: 1000,
      aggregateTimeout: 300
    };
    return config;
  }
};
