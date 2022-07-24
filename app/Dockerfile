
FROM nextcloud:apache

RUN \
	pecl update-channels && \
	pecl install xdebug && docker-php-ext-enable xdebug

RUN \
	apt-get update && \
	apt-get install -y npm less nano vim && \
	apt-get clean && \
	npm install -g npm

COPY install_composer.sh /tmp
RUN /tmp/install_composer.sh

COPY xdebug*.config /usr/local/share/xdebug/

RUN \
	v=$(php -v | grep -oi 'xdebug v[0-9]*' | sed 's@xdebug v@@i') && \
	if [ "$v" = 3 ]; then \
		cp /usr/local/share/xdebug/xdebug3.config /usr/local/etc/php/conf.d/zz-docker-php-ext-xdebug.ini; \
	elif [ "$v" = 2 ]; then \
		cp /usr/local/share/xdebug/xdebug2.config /usr/local/etc/php/conf.d/zz-docker-php-ext-xdebug.ini; \
	else \
		echo "Cannot detect PHP xdebug version." ; \
		exit 1; \
	fi && \
	sed 's@Timeout .*@Timeout 36000@g' -i /etc/apache2/apache2.conf && \
	cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

COPY entrypoint_custom.sh /
ENTRYPOINT ["/entrypoint_custom.sh"]
CMD ["apache2-foreground"]
