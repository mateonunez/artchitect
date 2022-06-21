FROM nginx:latest

ENV NGINX_PORT 80
ENV NGINX_HOST architect_nginx_balancer

ENV BALANCER_RUST_PORT 5500
ENV BALANCER_RUST_HOST architect_backend_rust_balancer

ENV BALANCER_JAVASCRIPT_PORT 5010
ENV BALANCER_JAVASCRIPT_HOST architect_backend_javascript_balancer

RUN rm -f /etc/nginx/conf.d/default.conf
RUN rm -f /etc/nginx/nginx.conf

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./balancer.conf /etc/nginx/balancer.tmpl
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["entrypoint.sh"]
