FROM php:7.4-apache

# Install PHP extensions and build tools for the battle engine
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev && \
    docker-php-ext-configure gd --with-jpeg --with-freetype && \
    docker-php-ext-install mysqli gd mbstring && \
    apt-get remove -y build-essential && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Copy application files
COPY wwwroot/ /var/www/html/
COPY game/ /var/www/html/game/

# Build the battle engine executable
WORKDIR /tmp/battle
COPY BattleEngine/battle.c BattleEngine/battle.h ./
RUN gcc battle.c -o battle -lm && \
    mkdir -p /var/www/cgi-bin && \
    mv battle /var/www/cgi-bin/battle && \
    chmod +x /var/www/cgi-bin/battle

WORKDIR /var/www/html
