#!/bin/bash


yum install wget  net-tools -y
IP=`ifconfig eth0|grep "inet "|awk '{print$2}'`
mkdir -p /usr/local/elk
cd /usr/local/elk
wget http://203.110.209.244:88/rpm/jdk-8u191-linux-x64.rpm
wget http://203.110.209.244:88/rpm/elasticsearch-6.2.3.tar.gz 
wget http://203.110.209.244:88/rpm/logstash-6.2.3.tar.gz
wget http://203.110.209.244:88/rpm/kibana-6.2.3-linux-x86_64.tar.gz

rpm -ivdh jdk-8u191-linux-x64.rpm


groupadd elasticsearch
useradd elasticsearch -g elasticsearch


hostname elk-server
echo elk-server > /etc/hostname
systemctl stop firewalld ; systemctl disable firewalld

cat >> /etc/security/limits.conf << EOF
*        hard    nproc           100000
*        soft    nproc           100000
*        hard    nofile           1024000
*        soft    nofile           1024000
EOF

echo vm.max_map_count=655360 >> /etc/sysctl.conf
sysctl -p



##############启动ElasticSearch,需要切换到elasticsearch用户#################
tar -xvf elasticsearch-6.2.3.tar.gz
tar -xvf logstash-6.2.3.tar.gz
tar -xvf kibana-6.2.3-linux-x86_64.tar.gz

chown -R elasticsearch.elasticsearch /usr/local/elasticsearch-6.2.3
su - elasticsearch << EOF
cd /usr/local/elk
nohup ./bin/elasticsearch -d &
exit
EOF


#############配置和启动Logstash###########################################
cd /usr/local/logstash-6.2.3
cat > default.conf << EOF
# 监听5044端口作为输入
input {
    beats {
        port => "5044"
    }
}
# 数据过滤
filter {
    grok {
        match => { "message" => "%{COMBINEDAPACHELOG}" }
    }
    geoip {
        source => "clientip"
    }
}
# 输出配置为本机的9200端口，这是ElasticSerach服务的监听端口
output {
    elasticsearch {
        hosts => ["127.0.0.1:9200"]
    }
}
EOF
nohup bin/logstash -f default.conf --config.reload.automatic &


#############配置和启动Kibana###########################################
cd /usr/local/kibana-6.2.3-linux-x86_64
sed -i 's/#server.host: "localhost"/server.host: "$IP"/g' config/kibana.yml
nohup bin/kibana &


###########配置和启动filebeat##########################################
cd /usr/local/filebeat-6.2.3-linux-x86_64

###########配置和启动elastalert#########################################

git clone https://github.com/Yelp/elastalert.git
pip install --upgrade
pip install "setuptools>=11.3"
python setup.py install
pip install "elasticsearch>=5.0.0"
########创建 ElastAlert 所需的索引#############################
elastalert-create-index

cat > config.yaml << EOF
rules_folder: /usr/local/work/elastalert/rule
run_every:
  minutes: 1
buffer_time:
  minutes: 15
es_host: 127.0.0.1
es_port: 9200
writeback_index: elastalert_status
alert_time_limit:
  days: 2
EOF

cat > rule/log.yaml << EOF
name: apierror
type: frequency
index: logstash-*  #监控这个索引
num_events: 3       #限定时间内,发生时间次数
timeframe:          #下定时间 ,跟上边的合起来就是一分钟有三个错误日志写进es的话,就发送邮件
  minutes: 1
filter:
- query:
    query_string:
      query: message:"error"
#  - regexp:
#      message: ".*"
#- term:
#    beat.name: "com-04"
alert:
- "email"
smtp_host: smtp.exmail.qq.com
smtp_port: 465
smtp_ssl: true
#用户认证文件，需要user和password两个属性
smtp_auth_file: /usr/local/work/elastalert/smtpfile.yaml
email_reply_to: "bruce.xiong@chinaentropy.com"
from_addr: "bruce.xiong@chinaentropy.com"
email:
- "xiongjianan100@sina.com"
EOF

nohup python -m elastalert.elastalert --config config.yaml --verbose --rule rule/log.yaml &

##################Elastalert trobleshotting#############################
pip install --upgrade --force-reinstall pip==9.0.3
pip install --upgrade --force-reinstall pip==9.0.3
pip uninstall PyYAML
pip install --upgrade pip
pip install elastalert
pip uninstall PyYAML
pip install --upgrade pip
pip install elastalert

