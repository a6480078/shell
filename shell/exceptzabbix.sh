#!/bin/bash
for i in `cat zabbixserver`;do 
expect <<EOF 
spawn ssh-copy-id zabbixuser@$i -p 2986
#expect "yes/no"  { send "yes\r" }
expect "*password:*" {send "123@qwe~~\r"}
#interact
#expect 
EOF
done
