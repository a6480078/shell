#! /bin/bash
while echo "Display current netconfig:"
do
select net in "ifconfig -a" "hosts"  "route -n" "quit"
do
case $net in
"ifconfig -a")
	clear
	/sbin/ifconfig -a
	read -s -n1;;
"hosts")
	clear
	cat /etc/hosts
	read -s -n1;;
"route -n")
	clear
	route -n
	read -s -n1;;
"quit")
	exit 0;;
*)
	continue;;
esac
break
done
done
