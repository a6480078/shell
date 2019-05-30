#!/bin/bash
mkdir -p /opt/jdk
tar -zxvf jdk-8u211-linux-x64.tar.gz -C /opt/jdk
echo "
export JAVA_HOME=/opt/jdk/jdk1.8.0_171
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH
" >> /etc/profile
source /etc/profile
java -version

