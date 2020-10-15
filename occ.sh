#!/bin/sh

docker-compose exec -u www-data app ./occ "$@"

