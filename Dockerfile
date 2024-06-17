#https://oralytics.com/2021/10/01/oracle-21c-xe-database-and-docker-setup/
#https://pastebin.com/RTPWt1XK
FROM php:8.2.4-fpm-bullseye

# Arguments defined in docker-compose.yml
ARG user
ARG uid

#Envs 
ENV APP_HOME /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libonig-dev \
    libpng-dev \
    libxml2-dev \
    libzip-dev \
    libssl-dev \
    zip \
    sudo \
    wget \
    libaio1 \
    libaio-dev \
    net-tools \
    libpq-dev

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && chmod +x /usr/local/bin/composer 



# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install gd mbstring bcmath soap zip sockets pdo_mysql


# Configure Redis
RUN pecl install igbinary

RUN pecl bundle redis && cd redis && phpize && \ 
    ./configure \
    --enable-redis-igbinary \
    && make \
    && make install

# Add application
WORKDIR $APP_HOME    

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user && echo "$user:$user" | chpasswd && usermod -aG sudo $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user && \
    chown -R $user:$user $APP_HOME

RUN chown -R $user:$user $APP_HOME

USER $user

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:9000
