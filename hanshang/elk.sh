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

