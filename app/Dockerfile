
FROM nextcloud:apache

RUN pecl install xdebug && docker-php-ext-enable xdebug

COPY xdebug.config /tmp/
RUN cat /tmp/xdebug.config >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
	rm /tmp/xdebug.config && \
	mkdir -p /traces
