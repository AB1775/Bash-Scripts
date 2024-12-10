#!/bin/bash

TARGET="8.8.8.8"
LOG_FILE="/path/to/NetworkOutage.log"

while true
do
	ping -4 -c 2 -W 5 $TARGET > /dev/null 2>&1

	if [ $? -ne 0 ]; then
		echo "$(date '+%Y-%m-%d %H:%M') - Internet Connection is Down" >> $LOG_FILE
	fi
	sleep 10
done
