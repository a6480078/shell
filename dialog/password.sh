#!/bin/bash
>test.txt

data=test.txt


dialog --title "password" \
--clear \
--passwordbox "Enter your password" 10 30 2> $data

response=$?

case $response in
0) echo "password is $(cat $data)";;
1) echo "Cancel pressed";;
255) [ -s $data ] && cat $data || echo "Esc pressed";;
esac
