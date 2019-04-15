#! /bin/bash
trap "" 2
clear
while true
do
echo "***********************"
echo "*1. Look ifcfg-eth0   *"
echo "*2. Look Rout Info    *"
echo "*3. Look Network Dev  *"
echo "*4. Exit              *"
echo "***********************"
echo -n "Select a Option:"
read number
	if [ $number = 1 ]
	then
	clear
#	cat /etc/sysconfig/network-scripts/ifcfg-eth0
	cat /etc/network/interfaces
	read -s -n1
	fi
	if [ $number = 2 ]
	then
	clear
	route -n
	read -s -n1
	fi
	if [ $number = 3 ]
	then
	clear
	ifconfig eth0
	read -s -n1
	fi
	if [ $number = 4 ]
	then
	break
	else
	clear
	continue
	fi
done
