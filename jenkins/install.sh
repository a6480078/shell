#!/bin/bash

yum install wget -y

###############安装 jdk###############################
#wget https://download.oracle.com/otn/java/jdk/8u211-b12/478a62b7d4e34b78b671c754eaaf38ab/jdk-8u211-linux-x64.rpm\?AuthParam\=1559025489_9d4d0b8d7e6d4eee970897ff4b4d140d
#rpm -ivdh jdk-8u211-linux-x64.rpm\?AuthParam=1559025489_9d4d0b8d7e6d4eee970897ff4b4d140d

###############下载 jenkins war 包###################
wget http://updates.jenkins-ci.org/download/war/2.179/jenkins.war
#端口改为8899
nohup java -jar /data/jenkins/jenkins.war --ajp13Port=-1 --httpPort=8888 &
