# Dockerfile (สำหรับ Production - Laravel PHP-FPM)
FROM php:8.1-fpm-alpine

# ติดตั้ง PHP Extensions ที่จำเป็นสำหรับ Laravel
RUN apk add --no-cache \
    zip libzip-dev \
    freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql gd zip

# ติดตั้ง Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# ตั้งค่าพื้นที่ทำงาน
WORKDIR /var/www

# ก๊อปปี้โค้ด Laravel ทั้งหมดเข้ามา
COPY . .

# รันติดตั้งแพ็กเกจ (ตัดตัวที่ใช้เทสต์ทิ้งด้วย --no-dev เพื่อความปลอดภัยและความเบา)
RUN composer install --no-dev --optimize-autoloader

# ตั้งค่าสิทธิ์ (Permissions) ให้ Laravel สามารถเขียนไฟล์ได้
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]
