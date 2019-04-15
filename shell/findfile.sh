#!/bin/bash

match=$1
found=0
[ $# -eq 0 ] && echo "Usage: bash $0 FILE NAME"
for i in /etc/*;do
    if [ $i == $match ];then
    found=1
    break
    fi
done

[ $found -eq 0 ] && echo "file $1 not found"
