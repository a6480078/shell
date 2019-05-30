#!/bin/bash

# 停止相关数据连接服务
gitlab-ctl stop unicorn
gitlab-ctl stop sidekiq

#执行命令从备份文件中恢复Gitlab
gitlab-rake gitlab:backup:restore BACKUP=1559009447_2019_05_28_11.11.0

#启动Gitlab
#gitlab-ctl start
