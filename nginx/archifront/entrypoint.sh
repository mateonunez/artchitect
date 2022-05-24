#!/bin/bash

envsubst '$NGINX_FPM_HOST' < /etc/nginx/archifront.tmpl > /etc/nginx/conf.d/default.conf
exec nginx -g "daemon off;"
