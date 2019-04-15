#!/bin/bash

for (( i=1; i<=9; i=i+1 ))
do
    for (( j=1; j<=i; j+=1 ))
    do
    # ((result=$i*$j))
    result=`expr $i \* $j`
    echo -ne $i\*$j=$result"\t"
    done
    echo
done