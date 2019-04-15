#!/bin/bash


a=`expr $RANDOM % 100`
echo $a
while true
do
read -p "input your number:" number
if [[ $number -eq $a ]];then
        echo "equel"
        break
elif [[ $number -gt $a ]]; then
        echo "too big"
#elif [[ $number -lt $a ]]; then
#       echo "too small"
else
        echo "too small"
fi
done