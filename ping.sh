#!/bin/bash
for i in `seq 1 254` ; do
	ping ‐c 2 -W 2 36.111.164.$i &> /dev/null
	if [[ $? -eq 0 ]]; then
		echo "36.111.164.$i is alive"
	else
		echo "36.111.164.$i is dead"
	fi
done
