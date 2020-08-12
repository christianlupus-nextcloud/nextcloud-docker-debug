#! /bin/sh

if [ "$(id -u)" = 0 ]; then
	
	mkdir -p /xdebug/profiles /xdebug/traces
	chown www-data /xdebug/*
	chmod a=rwx /xdebug/*
	
fi

exec /entrypoint.sh "$@"
