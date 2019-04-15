#! /bin/bash
for (( i=0; i<3; i++))
do
ping -q -c 2 192.168.1.$i
done
#arp -a | awk '{print $2,$4}' | grep -v "<incomplete>"  | sed 's/^(\(.*\))/\1/g'
arp -a | awk '{print $4}' | grep -v "<incomplete>"
