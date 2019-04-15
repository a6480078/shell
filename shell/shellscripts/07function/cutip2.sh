#! /bin/bash
for nic in $@
do
cutip () {
	ipaddr=`ifconfig $nic | grep "inet " | awk '{print $2}' | cut -d : -f 2`
	echo $ipaddr
}
cutip
done
