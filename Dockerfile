
FROM php:8.1-fpm


WORKDIR /var/www/html


RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip


RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


COPY . .


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --no-cache


RUN cd /var/www/html && composer install --no-dev --prefer-dist --optimize-autoloader

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 storage bootstrap/cache


EXPOSE 8000


CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
