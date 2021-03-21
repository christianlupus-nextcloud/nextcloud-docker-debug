#! /bin/sh

if [ -z "$DEBUG_USER_ID" ]; then
	echo "DEBUG_USER_ID not set correctly. Exiting..."
	exit 1
fi

if [ $(id -u) -ne 0 ]; then
	echo "This container must be run as user root. Exiting."
	exit 1
fi

# Update the UID of the debug user
sed "s@^www-data:\([^:]*\):[0-9]*:@www-data:\\1:$DEBUG_USER_ID:@" -i /etc/passwd

chown -R www-data /var/www/html /xdebug

mkdir -p /xdebug/profiles /xdebug/traces
chown www-data /xdebug/*
chmod a=rwx /xdebug/*

exec /entrypoint.sh "$@"
