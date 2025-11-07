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
    && docker-php-ext-install gd mbstring zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Apache rewrite module
RUN a2enmod rewrite

# Copy Bludit files into the container
COPY . /var/www/html/

# Set correct ownership and permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 775 /var/www/html/bl-content && \
    chmod 664 /var/www/html/.htaccess || true

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
