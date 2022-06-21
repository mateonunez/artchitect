FROM php:8.0-fpm

# Install Composer
ENV COMPOSER_VERSION 2.3.5

# Setting Env variables
ENV DB_HOST architect_database_mysql
ENV DB_PORT 3306
ENV DB_DATABASE architect_database_mysql
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

COPY .env .env
COPY .env.testing .env.testing

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

# Exposing port
EXPOSE 9000

RUN envsubst '${DB_HOST},${DB_PORT},${DB_DATABASE},${DB_USERNAME},${DB_PASSWORD},${RABBITMQ_HOST},${RABBITMQ_PORT},${RABBITMQ_USER},${RABBITMQ_PASS}' < /usr/src/architect/backend/php/laravel/.env

CMD ["php", "artisan", "queue:work"]
