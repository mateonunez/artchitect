#!/bin/bash

envsubst '${DB_HOST},${DB_PORT},${DB_DATABASE},${DB_USERNAME},${DB_PASSWORD},${RABBITMQ_HOST}${RABBITMQ_PORT},${RABBITMQ_USER}${RABBITMQ_PASS}' < /usr/src/architect/backend/php/laravel/.env

exec cd /usr/src/architect/backend/php/laravel && composer install && php artisan migrate:fresh --seed && php artisan passport:install
exec chown -R $USER:www-data . && find . -type f -exec chmod 664 {} \; && find . -type d -exec chmod 775 {} \; && chgrp -R www-data storage bootstrap/cache && chmod -R ug+rwx storage bootstrap/cache
