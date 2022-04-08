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
docker-compose exec sabickend_laravel composer install
docker-compose exec sabickend_laravel php artisan prepare:env
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
docker-compose exec sabickend_laravel php artisan migrate:fresh --seed --env=testing
docker-compose exec sabickend_laravel php artisan passport:install --env=testing
docker-compose exec sabickend_laravel php artisan test 
```
