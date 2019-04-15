#!/bin/bash


ssh-keygen << EOF


y


EOF

expect 2>/dev/null <<EOF
spawn ssh-copy-id -o "StrictHostKeyChecking no" root@node1
expect "*assword*"
send "r00tme\n"
#expect "*$*"
#send "echo test\n"
#expect "*$*"
#send "exit\n"
expect eof
EOF
expect 2>/dev/null <<EOF
spawn ssh-copy-id -o "StrictHostKeyChecking no" root@node2
expect "*assword*"
send "r00tme\n"
#expect "*$*"
#send "echo test\n"
#expect "*$*"
#send "exit\n"
expect eof
EOF
expect 2>/dev/null <<EOF
spawn ssh-copy-id -o "StrictHostKeyChecking no" root@node3
expect "*assword*"
send "r00tme\n"
#expect "*$*"
#send "echo test\n"
#expect "*$*"
#send "exit\n"
expect eof
EOF

