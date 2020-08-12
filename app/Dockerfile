
FROM nextcloud:apache

RUN pecl install xdebug && docker-php-ext-enable xdebug

COPY xdebug.config /tmp/
RUN cat /tmp/xdebug.config >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
	rm /tmp/xdebug.config && \
	mkdir -p /xdebug/traces /xdebug/profiles && \
	sed 's@Timeout .*@Timeout 36000@g' -i /etc/apache2/apache2.conf

COPY entrypoint_custom.sh /
ENTRYPOINT ["/entrypoint_custom.sh"]
CMD ["apache2-foreground"]
