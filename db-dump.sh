#!/bin/bash

docker-compose exec db mysqldump -u nextcloud -pnextcloud_pwd nextcloud

