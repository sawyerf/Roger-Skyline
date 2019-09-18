#!/bin/bash

FILE="/etc/crontab"
NEW=$(md5sum $FILE)
OLD=''
OLD=$(cat /var/log/hash_crontab)
if [ "$OLD" != "$NEW" ]; then
	echo "$NEW" > /var/log/hash_crontab
	mail -s "/etc/crontab a ete change" root < /dev/null
	echo "Ca a change"
fi
