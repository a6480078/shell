#!/bin/bash


myping(){
	/sbin/ping -c 1 -i 0.3 -W 1 36.111.164.$1 &> /dev/null
	if [[ $? -eq 0 ]]; then
		echo "36.111.164.$1 is up"
#	else
#		echo "36.111.164.$1 is down"
	fi
}
for (( i = 1; i < 255; i++ )); do
	myping $i
done
