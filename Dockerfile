FROM debian:bullseye-slim
RUN apt-get -y update && \
    apt-get -y -q --no-install-recommends install \
		apache2 \
		ca-certificates \
		openssl \
		php php-mysql \
		php-curl php-mbstring php-xml php-curl php-gd \
		php-bz2 php-zip php-intl php-ldap \
	&& apt-get -y clean

ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_PID_FILE $APACHE_RUN_DIR/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV LANG C

RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR

# make CustomLog (access log) go to stdout instead of files
# and ErrorLog to stderr
#RUN find "$APACHE_CONFDIR" -type f -exec sed -ri ' \
#	s!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g; \
#	s!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g; \
#' '{}' ';'

COPY --chown=$APACHE_RUN_USER:$APACHE_RUN_GROUP ./glpi /var/www/html/glpi

COPY ./glpi.conf $APACHE_CONFDIR/sites-available

RUN a2enmod ssl rewrite proxy proxy_http && \
    a2dissite 000-default && \
    a2ensite glpi

EXPOSE 80

CMD ["apache2", "-DFOREGROUND"]


