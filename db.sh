#!/bin/bash

if [ -t 0 ]; then
	docker-compose exec db mysql -u nextcloud -pnextcloud_pwd nextcloud
else
	echo 'Running without tty'
	docker-compose exec -T db mysql -u nextcloud -pnextcloud_pwd nextcloud
fi


