#!/bin/bash

envsubst '$NGINX_FPM_HOST' < /etc/nginx/balancer.tmpl > /etc/nginx/conf.d/default.conf
exec nginx -g "daemon off;"
