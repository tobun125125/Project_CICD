#!/bin/bash
set -e

echo "========================================="
echo "  Hospital System — Docker Dev Setup"
echo "========================================="

# 1. ติดตั้ง Composer packages (ถ้ายังไม่มี vendor/)
if [ ! -d "/var/www/vendor" ] || [ ! -f "/var/www/vendor/autoload.php" ]; then
    echo "📦 Installing Composer dependencies..."
    composer install --no-interaction --prefer-dist
else
    echo "✅ Composer dependencies already installed."
fi

# 2. สร้าง .env ถ้ายังไม่มี
if [ ! -f "/var/www/.env" ]; then
    echo "📋 Creating .env from .env.example..."
    cp .env.example .env
fi

# 3. สร้าง APP_KEY ถ้ายังไม่มี
if grep -q "APP_KEY=$" /var/www/.env || grep -q "APP_KEY=base64:" /var/www/.env; then
    echo "🔑 APP_KEY already exists, skipping..."
else
    echo "🔑 Generating APP_KEY..."
    php artisan key:generate --force
fi

# 4. รอ MySQL พร้อม
echo "⏳ Waiting for MySQL to be ready..."
max_retries=30
counter=0
until php artisan db:monitor --databases=mysql > /dev/null 2>&1 || mysql -h"$DB_HOST" -u"$DB_USERNAME" -p"$DB_PASSWORD" "$DB_DATABASE" -e "SELECT 1" > /dev/null 2>&1; do
    counter=$((counter + 1))
    if [ $counter -ge $max_retries ]; then
        echo "⚠️ MySQL not ready after ${max_retries} attempts, continuing anyway..."
        break
    fi
    echo "  Waiting for MySQL... (${counter}/${max_retries})"
    sleep 2
done

# 5. รัน Migration
echo "🗄️ Running database migrations..."
php artisan migrate --force 2>/dev/null || echo "⚠️ Migration skipped (DB may not be ready yet)"

# 6. ตั้งค่า Permissions
echo "🔒 Setting permissions..."
chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache 2>/dev/null || true
chmod -R 775 /var/www/storage /var/www/bootstrap/cache 2>/dev/null || true

echo "========================================="
echo "  ✅ Hospital System Ready!"
echo "  🌐 http://localhost:8000"
echo "========================================="

# 7. รัน PHP-FPM
exec php-fpm
