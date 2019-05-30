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


cat >> /etc/security/limits.conf << EOF
*        hard    nproc           100000
*        soft    nproc           100000
*        hard    nofile           1024000
*        soft    nofile           1024000
* soft  memlock  unlimited
* hard memlock  unlimited
EOF
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
