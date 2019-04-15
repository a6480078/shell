#!/bin/bash
for i in `cat zabbixdb`;do 
expect <<EOF 
spawn ssh-copy-id mysqluser@$i -p 2986
expect "yes/no"  { send "yes\r" }
expect "*assword:*"
send "123@qwe~~\r"
interact
expect 
EOF
done
