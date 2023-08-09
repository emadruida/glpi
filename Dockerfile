FROM emadruida/php-glpi:main

# Download GLPI
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
RUN curl -sSLf https://github.com/glpi-project/glpi/releases/download/10.0.9/glpi-10.0.9.tgz | tar -zx \
	&& chown -R $APACHE_RUN_USER:$APACHE_RUN_GROUP glpi

# Configure Apache
COPY ./conf.d/glpi.conf $APACHE_CONFDIR/sites-available
RUN a2enmod rewrite && a2dissite 000-default && a2ensite glpi
