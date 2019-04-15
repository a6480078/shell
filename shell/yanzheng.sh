#!/bin/bash

cat /etc/redhat-release |grep 7.5 &> /dev/null && echo "release yes" || echo 'release no'
/usr/bin/lscpu |grep 'CPU(s)' |grep 40 &> /dev/null && echo "CPU yes" || echo 'CPU no'

/usr/bin/free -h|grep 251 &> /dev/null && echo "RAM yes" || echo "RAM no"
/usr/bin/lsblk |egrep '1T|2.2T' &> /dev/null && echo "disk yes" || echo "disk no"
# mkdir /app 
#mkfs.xfs -f -i attr=2 -l lazy-count=1,sectsize=4096 -b size=4096 -d sectsize=4096 -L data /dev/sdb
#mount -o rw,noatime,nodiratime,noikeep,nobarrier,allocsize=100M,attr2,largeio,inode64,swalloc /dev/sdb /app
ls -l /dev/disk/by-uuid |awk '{print$9}' > ~/UUID
echo "UUID=`cat ~/UUID` /app xfs  rw,noatime,nodiratime,noikeep,nobarrier,allocsize=100M,attr2,largeio,inode64,swalloc    0 0" >> /etc/fstab

