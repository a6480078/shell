#!/bin/bash
for (( i = 1; i < 254; i++ )); do
{
     /usr/bin/ping -c 1 -W 1 -i 0.5 36.111.164.$i &> /dev/null 
	if [ $? -eq 0 ]; then
		echo "36.111.164.$i is alive"
	#else
	#	echo "36.111.164.$i is dead"
	fi
} &
done 
wait
