FROM nginx:1.24@sha256:4dbab43c337f11f377e6ba798a490be1961b9b92a86a18e78748588c3b2d98f2

# Setting environment variables
ENV ARCHIVEL_HOST archivel_1
ENV ARCHIVEL_PORT 9000
ENV ARCHIVEL_HOST_2 archivel_2
ENV ARCHIVEL_PORT_2 9000

ENV NGINX_PORT 80
ENV NGINX_ROOT /usr/src/architect/backend/php/laravel/public

# Removing default configurations
RUN rm -f /etc/nginx/conf.d/default.conf
RUN rm -f /etc/nginx/nginx.conf

# Setting working dir
WORKDIR /etc/nginx

# Copying nginx and laravel configuration files
COPY nginx.conf nginx.conf
COPY laravel.conf laravel.conf

# Copy and set permissions on entrypoint file
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Exposing 80 port
EXPOSE 80

ENTRYPOINT ["entrypoint.sh"]
