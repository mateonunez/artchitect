FROM php:8.2-fpm@sha256:c63f57dec021674980e1eea4939996b964c3117d4dbe7d2a6c5829673a90dd4e

# Install Composer
ENV COMPOSER_VERSION 2.3.5

# Setting Env variables
ENV KONG_GATEWAY_ENDPOINT http://kong:8000

ENV DB_HOST architect_mysql
ENV DB_PORT 3306
ENV DB_DATABASE architect_mysql
ENV DB_USERNAME architect
ENV DB_PASSWORD architect

ENV RABBITMQ_HOST architect_rabbitmq
ENV RABBITMQ_PORT 5672
ENV RABBITMQ_USER architect
ENV RABBITMQ_PASS architect

# Installing composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=$COMPOSER_VERSION

# Installing dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    gettext \
    libz-dev \
    libpq-dev \
    libjpeg-dev \
    libpng-dev \
    libssl-dev \
    libzip-dev \
    supervisor \
    vim \
    unzip \
    zip \
    && apt-get clean \
    && docker-php-ext-configure gd \
    && docker-php-ext-configure zip \
    && docker-php-ext-install \
    gd \
    exif \
    opcache \
    pdo_mysql \
    pcntl \
    sockets \
    zip \
    && rm -rf /var/lib/apt/lists/*;

# Copying php configuration
COPY ./.docker/php/php.ini /usr/local/etc/php/conf.d/php.ini

# Creating and manage laravel project's path
WORKDIR /usr/src/architect/backend/php/laravel/

COPY composer.json composer.json
COPY composer.lock composer.lock

COPY .env.example .env
COPY .env.testing.example .env.testing

COPY artisan artisan

COPY phpcs.xml.dist phpcs.xml.dist
COPY phpunit.xml phpunit.xml

COPY app app
COPY bootstrap bootstrap
COPY config config
COPY database database
COPY lang lang
COPY public public
COPY routes routes
COPY storage storage
COPY tests tests

RUN envsubst '${DB_HOST},${DB_PORT},${DB_DATABASE},${DB_USERNAME},${DB_PASSWORD},${RABBITMQ_HOST},${RABBITMQ_PORT},${RABBITMQ_USER},${RABBITMQ_PASS}' < .env
RUN envsubst '${DB_HOST},${DB_PORT},${DB_DATABASE},${DB_USERNAME},${DB_PASSWORD}' < .env.testing

# Supervisor configuration
COPY ./.docker/php/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Touching log files
RUN touch /var/log/php-error.log && chmod 0644 /var/log/php-error.log
RUN touch /var/log/php-access.log && chmod 0644 /var/log/php-access.log
RUN touch /var/log/supervisord.log && chmod 0644 /var/log/supervisord.log

# Optimizing
RUN composer install --optimize-autoloader --no-dev

# RUN php artisan key:generate
# RUN php artisan optimize
# RUN php artisan config:cache
# RUN php artisan migrate
# RUN php artisan passport:install

# Exposing port
EXPOSE 9000

# Running supervisord
CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisor/conf.d/supervisord.conf"]
