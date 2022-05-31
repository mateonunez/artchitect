FROM php:8.0-fpm

# Install Composer
ENV COMPOSER_VERSION 2.1.5

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=$COMPOSER_VERSION

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libz-dev \
    libpq-dev \
    libjpeg-dev \
    libpng-dev \
    libssl-dev \
    libzip-dev \
    unzip \
    zip \
    nodejs \
    && apt-get clean \
    && pecl install redis \
    && docker-php-ext-configure gd \
    && docker-php-ext-configure zip \
    && docker-php-ext-install \
    gd \
    exif \
    opcache \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    pcntl \
    sockets \
    zip \
    && docker-php-ext-enable redis \
    && rm -rf /var/lib/apt/lists/*;

COPY ./.docker/php/php.ini /usr/local/etc/php/conf.d/php.ini

WORKDIR /usr/src/architect/backend/php/laravel

COPY ./ /usr/src/architect/backend/php/laravel/

RUN chown -R www-data:www-data .
