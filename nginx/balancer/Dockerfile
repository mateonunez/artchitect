FROM nginx:1.24@sha256:0bdc6959fe6df99b5fdebc871a7325d1ee8d6a6be00c571e3592bc6cd472ccd7

ENV NGINX_PORT 80
ENV NGINX_HOST balancer_nginx

ENV BALANCER_RUST_PORT 5500
ENV BALANCER_RUST_HOST balancer_rust

ENV BALANCER_JAVASCRIPT_PORT 5010
ENV BALANCER_JAVASCRIPT_HOST balancer_javascript

RUN rm -f /etc/nginx/conf.d/default.conf
RUN rm -f /etc/nginx/nginx.conf

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./balancer.conf /etc/nginx/balancer.tmpl
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["entrypoint.sh"]
