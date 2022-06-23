#!/bin/bash

envsubst '${NGINX_ROOT},${NGINX_PORT},${ARCHIVEL_HOST},${ARCHIVEL_PORT},${ARCHIVEL_HOST_2},${ARCHIVEL_PORT_2}' < /etc/nginx/laravel.conf > /etc/nginx/conf.d/default.conf

exec nginx -g "daemon off;"
