FROM nginx:latest

# Setting environment variables
ENV ARCHIVEL_HOST architect_backend_php_laravel
ENV ARCHIVEL_PORT 9000
ENV NGINX_PORT 8000 
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

# Exposing 8000 port
EXPOSE 8000

ENTRYPOINT ["entrypoint.sh"]
