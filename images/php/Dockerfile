FROM php:8.2-fpm

# Arguments defined in docker-compose.yml
ARG USER=eu
ARG UID=1000

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    && pecl install redis \
    && docker-php-ext-enable redis

#RUN pecl install xdebug && docker-php-ext-enable xdebug

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands

RUN useradd -u $UID -G www-data,root -d /home/$USER $USER && echo "$USER:$USER" | chpasswd && adduser $USER sudo
RUN mkdir -p /home/$USER/.composer
RUN chown -R $USER:$USER /home/$USER


#RUN useradd -G www-data,root -u $uid -d /home/$user $user
#RUN mkdir -p /home/$user/.composer && \
#    chown -R $user:$user /home/$user

# Set working directory
WORKDIR /var/www

USER $USER
