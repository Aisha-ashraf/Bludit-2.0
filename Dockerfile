# Base image
FROM php:8.2-apache

# Install required dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zlib1g-dev \
    libzip-dev \
    libonig-dev \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mbstring zip

# Enable Apache rewrite module
RUN a2enmod rewrite

# Copy Bludit files into the container
COPY . /var/www/html/

# Allow .htaccess and fix permissions
RUN echo "<Directory /var/www/html/> \n\
    AllowOverride All \n\
    Require all granted \n\
    </Directory>" > /etc/apache2/conf-available/bludit.conf \
    && a2enconf bludit \
    && chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
