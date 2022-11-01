#! /bin/bash

if [ $# -eq 0 ]; then
	$1 = '.message.Message, .message.Trace[0:2]'
fi

tail -n1 -f volumes/data/nextcloud.log  | while read l; do echo "$l" | sed 's@\\@\\\\@g' | jq "$1" ; echo '********************************'; done
