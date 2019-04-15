#!/bin/bash

###########关闭防火墙和selinux######################################
systemctl stop firewalld && systemctl disable firewalld
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

###########用户登录3次失败就锁定账户################################
echo "account required pam_tally.so deny=3 unlock_time=60" >> /etc/pam.d/system-auth

###########用户设置的密码必须包含5个数字，3个特殊符号###############
echo "password requisite pam_cracklib.so try_first_pass retry=3 dcredit=5,ocredit=3" >> /etc/pam.d/system-auth

############创建用户####################################
useradd bruce.xiong && echo "user bruce.xiong is created"
useradd henry.deng && echo "user henry.deng is created"
useradd steve.qiao && echo "user steve.qiao is created"
useradd michael.liu && echo "user michael.liu is created"
useradd jhin.sun && echo "uesr jhin.sun is created"

cat >> user.txt << EOF
bruce.xiong     ALL=(ALL)       NOPASSWD: ALL
michael.liu     ALL=(ALL)       NOPASSWD: ALL
jhin.sun        ALL=(ALL)       NOPASSWD: ALL
henry.deng        ALL=(ALL)       NOPASSWD: ALL
steve.qiao        ALL=(ALL)       NOPASSWD: ALL
EOF

echo "user.txt is created"


############初始化密码#################################
for i in `awk '{print$1}' user.txt`
do
echo changeme |passwd --stdin $i
done


echo "All users' password is initialized"

############给 sudo nopasswd 权限######################
cat user.txt >> /etc/sudoers && echo "ALL users' have sudo nopass permission"

echo
echo


#######配置ssh连接，改变连接速度######################
sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g' /etc/ssh/sshd_config     #####关闭server上的GSS认证
sed -i 's/#IgnoreRhosts yes/IgnoreRhosts yes/g' /etc/ssh/sshd_config
echo "ssh configuration is completed"

echo 
echo
########替换yum Base源为阿里源######################

curl http://mirrors.aliyun.com/repo/Centos-7.repo > /etc/yum.repos.d/CentOS-Base.repo
echo "update yum repo is successful"
echo
echo



############更新内核版本##################################
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
sleep 5
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
sleep 5
yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
yum --enablerepo=elrepo-kernel install kernel-lt -y
echo "kernel is updated"
###########修改默认启动内核##################################
sed -i 's/GRUB_DEFAULT=saved/GRUB_DEFAULT=0/g' /etc/default/grub
sleep 5
grub2-mkconfig -o /boot/grub2/grub.cfg
echo "default kernel boot is updated"



##########使用iscsiadm连接Lenovo存储#########################
yum install -y iscsi-initiator-utils
systemctl start iscsid && systemctl enable  iscsid
iscsiadm -m node  -L all

echo "iscsid is installed"


##########配置multipath######################################
yum install device-mapper device-mapper-multipath -y
modprobe dm-multipath
modprobe dm-round-robin
systemctl start multipathd ; systemctl enable multipathd
/sbin/mpathconf
mpathconf --enable --with_multipathd y
multipath -ll
