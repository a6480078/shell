#!/bin/bash
for (( i = 1; i < 254; i++ )); do
     /sbin/ping -c 1 -W 1 -i 0.3 36.111.164.$i &> /dev/null
	if [ $? -eq 0 ]; then
		echo "36.111.164.$i is alive"
	#else
	#	echo "36.111.164.$i is dead"
	fi
done