#!/bin/bash

envsubst '$NGINX_HOST,$ARCHIFRONT_HOMEPAGE_HOST,$ARCHIFRONT_AUTHENTICATION_HOST' < /etc/nginx/archifront.tmpl > /etc/nginx/conf.d/default.conf

exec nginx -g "daemon off;"
