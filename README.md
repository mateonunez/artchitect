# Architect

## Backend PHP Laravel

### Installation

Set your environment variables

```bash
DB_CONNECTION=mysql
DB_HOST=architect_database
DB_PORT=3306
DB_DATABASE=architect
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
DB_HOST=architect_database
DB_PORT=3306
DB_DATABASE=architect_test
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

## Backend Javascript Balancer

This simple backend is used just for activate a balancing strategy

### Set up

Set your environment variables

```bash
BALANCER_HOST=architect_backend_javascript_balancer
BALANCER_PORT=5010
```

Then run the `docker-compose` commands

```bash
docker-compose build && docker-compose up -d
```

After the installation you must run the following commands:

```bash
docker-compose exec architect_backend_javascript_balancer npm run install
```

## Backend Rust Balancer

This simple backend is used just for activate a balancing strategy

Run the `docker-compose` commands

```bash
docker-compose build && docker-compose up -d
```
