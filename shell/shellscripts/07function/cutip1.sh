#! /bin/bash
nic=$*
if [ -n $nic ]
then
cutip () {
	ipaddr=`ifconfig $nic | grep "inet " | awk '{print $2}' | cut -d : -f 2`
	echo $ipaddr
}
cutip
else
	ifconfig | grep "inet " | awk '{print $2}' | cut -d : -f 2
fi
