FROM php:8.2-apache

# Configure PHP extensions for GLPI
RUN apt-get update && apt-get install -y \
		libfreetype-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
        libicu-dev \
        libldap2-dev \
        libbz2-dev \
        libzip-dev \
    && docker-php-ext-install mysqli \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install intl \
    && docker-php-ext-install exif \
    && docker-php-ext-install ldap \
    && docker-php-ext-install bz2 \
    && docker-php-ext-install zip \
    && docker-php-ext-install opcache \
    && apt-get -y clean

COPY ./conf.d/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && sed -i -E "s/(.*)(session.cookie_httponly =).*/\2 On/g" "$PHP_INI_DIR/php.ini"

# Download GLPI
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
RUN curl -sSLf https://github.com/glpi-project/glpi/releases/download/10.0.9/glpi-10.0.9.tgz | tar -zx \
	&& chown -R $APACHE_RUN_USER:$APACHE_RUN_GROUP glpi

# Configure Apache
COPY ./conf.d/glpi.conf $APACHE_CONFDIR/sites-available
RUN a2enmod rewrite && a2dissite 000-default && a2ensite glpi
