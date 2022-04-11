# Architect

## Backend PHP Laravel

### Installation

Set your environment variables

```bash
DB_CONNECTION=mysql
DB_HOST=sabickend_database
DB_PORT=3306
DB_DATABASE=sabickend
DB_USERNAME=root
DB_PASSWORD=root
```

Then run the `docker-compose` commands

```bash
docker-compose build && docker-compose up -d
```

After the installation you must run the following commands:

```bash
docker-compose exec architect_backend_php_laravel composer install
docker-compose exec architect_backend_php_laravel php artisan prepare:env
```

### Testing

Set your environment variables

```env
DB_CONNECTION=mysql
DB_HOST=sabickend_database
DB_PORT=3306
DB_DATABASE=sabickend_test
DB_USERNAME=root
DB_PASSWORD=root
```

Then run the `docker-compose` commands

```bash
docker-compose exec architect_backend_php_laravel php artisan migrate:fresh --seed --env=testing
docker-compose exec architect_backend_php_laravel php artisan passport:install --env=testing
docker-compose exec architect_backend_php_laravel php artisan test 
```

## Backend Javascript Watchful

Watchful is a simple program that checks and handles the queue.

### Set up

Set your environment variables

```bash
RABBITMQ_HOST=architect_rabbitmq
RABBITMQ_PORT=5672
RABBITMQ_USER=architect
RABBITMQ_PASS=architect
```

Then run the `docker-compose` commands

```bash
docker-compose build && docker-compose up -d
```

After the installation you must run the following commands:

```bash
docker-compose exec architect_backend_javascript_watchful npm run install
```
