#!/bin/bash

yum install curl policycoreutils openssh-server openssh-clients postfix -y
curl -sS http://packages.gitlab.com.cn/install/gitlab-ce/script.rpm.sh | sudo bash
yum install gitlab-ce -y
gitlab-ctl reconfigure

