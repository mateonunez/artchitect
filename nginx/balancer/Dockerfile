FROM nginx:1.24@sha256:22cb51c7e9e05724dd1c46789e15cdb78617d1904c7c78a2829c8550c6b46e40

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
