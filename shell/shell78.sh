#!/bin/bash

list=(1 1)
for i in `seq 2 13`; do
	# a=`expr $i - 2`
	# b=`expr $i - 1`
	# list[$i]=`expr ${list[$a]} + ${list[$b]}`
	num1=${list[i-2]}
	num2=${list[i-1]}
	list[i]=$[num1+num2]
done
echo ${list[*]}
echo ${#list[*]}
sum=0
for (( i = 0; i < 14; i++ )); do
	# sum=`expr $sum + ${list[i]}`
	sum=$[$sum+${list[i]}]
done
echo $sum