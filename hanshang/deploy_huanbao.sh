#!/bin/bash


yum install wget -y
#wget http://203.110.209.244:88/rpm/Python-3.6.5.tgz
wget http://203.110.209.244:88/rpm/jdk-8u191-linux-x64.rpm

#############安装jdk##########################################
rpm -ivdh jdk-8u191-linux-x64.rpm
echo
echo
echo "###########################################"
echo "#  jdk           is              installed#"
echo "###########################################"

#############安装python3.6.5###################################
#yum groupinstall 'Development Tools' -y && yum install zlib-devel bzip2-devel  openssl-devel ncurses-devel -y
#if [ $? -eq 0 ];then
#sleep 1
#tar -zxvf Python-3.6.5.tgz
#cd Python-3.6.5/
#./configure --prefix=/usr/local/python3 --enable-optimizations
#make
#make install
#fi
#echo "PATH=$PATH:/usr/local/python3/bin" >> /etc/profile
#source /etc/profile
yum install epel-release -y
yum install https://centos7.iuscommunity.org/ius-release.rpm -y
yum  install python36u -y
yum install python36u-pip -y
echo
echo
echo "###########################################"
echo "#  python3.6  and pip         is installed#"
echo "###########################################"

##########安装pipenv#########################################
pip3.6 install --upgrade pip
pip3.6 install pipenv
sleep 1
cd /data/aqi-crawler-v1
pipenv --python 3.6
pipenv lock
pipenv sync
#pipenv shell
#exit 
pipenv run python --version
echo
echo
echo "###########################################"
echo "#  pipenv        is              installed#"
echo "###########################################"


#########安装docker-compose###################################
pip3.6 install docker-compose
echo
echo
echo "###########################################"
echo "#  docker-compose     is         installed#"
echo "###########################################"


#########安装clickhouse-client################################
cd /data/clickhouse/rpm
rpm -ivdh libicu-50.1.2-17.el7.x86_64.rpm
rpm -ivdh clickhouse-common-static-19.3.6-1.el7.x86_64.rpm
rpm -ivdh clickhouse-server-common-19.3.6-1.el7.x86_64.rpm
rpm -ivdh clickhouse-server-19.3.6-1.el7.x86_64.rpm clickhouse-client-19.3.6-1.el7.x86_64.rpm 
systemctl disable clickhouse-server
systemctl stop clickhouse-server
echo
echo
echo "###########################################"
echo "#  clickhouse-client       is    installed#"
echo "###########################################"


#########安装docker##############################################
yum install docker -y
echo
echo
echo "###########################################"
echo "#  docker           is           installed#"
echo "###########################################"
