#!/bin/bash

cd /usr/local/work/logstash-6.2.3
nohup bin/logstash -f default.conf --config.reload.automatic &

