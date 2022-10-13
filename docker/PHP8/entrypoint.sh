#!/bin/bash

set -e;

if [ ! -f /var/www/cutcode-tz.local/.env ]; then
  cp "/var/www/cutcode-tz.local/.env.example" "/var/www/cutcode-tz.local/.env";
fi

if [ ! -f /var/www/cutcode-tz.local/vendor/autoload.php ]; then
    php -d memory_limit=-1 /usr/local/bin/composer install --working-dir=/var/www/cutcode-tz.local 2>&1 || true;
    cd "/var/www/cutcode-tz.local";
    yes | php artisan key:generate;
    php artisan migrate;
    php artisan storage:link;
    php artisan optimize;
fi

php-fpm;

tail -f /home/entrypoints.sh;
