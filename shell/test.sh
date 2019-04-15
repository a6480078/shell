#!/bin/bash
read -p "Please input a character: " Cha
m=`echo $Cha | grep '[a-zA-Z]'|grep -v '[0-9]'`
n=`echo $Cha | grep '[0-9]'|grep -v '[a-zA-Z]'`
s=`echo $Cha | grep '[a-zA-Z]'|grep '[0-9]'`
if [[ -n $m  ]] ; then
echo "字母"
elif [[ -n $n ]] ; then
echo "数字"
elif [[ -n $s ]] ; then
echo "数字字母"
else
echo "your input is 特殊字符"
fi