#! /bin/bash
#use=`df -h|sed "1d"|cut -d"%" -f1|awk '{print$5}'`
for nu in $(df -h|sed "1d"|cut -d"%" -f1|awk '{print$5}')
do
	if [ $nu -gt 10 ]
	then
	disk=`df -h | sed "1d" | awk '{print $1}'`
	echo $disk $nu
	fi
done
