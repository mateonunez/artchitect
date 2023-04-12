FROM nginx:1.24@sha256:fc6ecdf9b653238a3f37e6f41dfdf8eddc99c38b0949ecd2995bc4fa5f31ec61

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
