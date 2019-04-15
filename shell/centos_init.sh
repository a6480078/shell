#!/bin/bash


systemctl stop firewalld && systemctl disable firewalld && echo "firewalld was closed";setenforce 0;sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux;echo "selinux was closed"


sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
