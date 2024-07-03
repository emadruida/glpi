FROM emadruida/php-glpi:latest

# Download GLPI
ARG GLPI_VERSION=10.0.16
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
RUN curl -sSLf https://github.com/glpi-project/glpi/releases/download/${GLPI_VERSION}/glpi-${GLPI_VERSION}.tgz | tar -zx \
	&& chown -R ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} glpi

# Configure Apache
COPY ./conf.d/glpi.conf $APACHE_CONFDIR/sites-available
RUN a2enmod rewrite && a2dissite 000-default && a2ensite glpi
