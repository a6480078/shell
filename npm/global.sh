#!/bin/bash

##1.新建一个全局安装的路径
mkdir -p /opt/npm-global
##2.配置npm使用新的路径
npm config set prefix '/opt/npm-global'
##3.打开或者新建~/.profile，加入下面一行
echo "
export PATH=/opt/npm-global/bin:$PATH
" >> /etc/profile
##4、更新系统环境变量
source /etc/profile
npm config get prefix
