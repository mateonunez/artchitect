FROM nginx:1.24@sha256:4dbab43c337f11f377e6ba798a490be1961b9b92a86a18e78748588c3b2d98f2

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
