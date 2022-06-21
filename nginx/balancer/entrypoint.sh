#!/bin/bash

envsubst '${NGINX_HOST},${NGINX_PORT},${BALANCER_RUST_PORT},${BALANCER_RUST_HOST},${BALANCER_JAVASCRIPT_PORT},${BALANCER_JAVASCRIPT_HOST}' < /etc/nginx/balancer.tmpl > /etc/nginx/conf.d/default.conf

exec nginx -g "daemon off;"
