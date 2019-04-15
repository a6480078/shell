#!/bin/bash

#function(){
while IFS=" " read i j ;do
#echo $i
#echo $j
/usr/bin/expect <<EOF
spawn ssh $i
#expect "yes/no"  { send "yes\r" }
expect "password:" {send "$j\r"}
expect "#" { send "top -bi -n 1 -d 0.02  |grep Cpu\r" }
expect "#" { send "free -g |grep  Mem >>xitong.txt \r" }
expect "#" { send "df -h >>xitong.txt \r" }
expect "#" { send "uptime >>xitong.txt \r" }
expect "#" { send "cat xitong.txt \r" }
expect "#" { send "rm -rf xitong.txt \r" }
expect "#" { send "systemctl status libvirtd.service |grep running \r" }
expect "#" { send "systemctl status neutron-openvswitch-agent.service |grep running \r" }
expect "#" { send "systemctl status openstack-nova-compute.service | grep running \r" }
expect "#" { send "systemctl status neutron-lbaas-agent.service  |grep running \r" }
expect "#" { send "quit \r" }
EOF
done < password.txt
