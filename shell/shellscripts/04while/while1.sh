#! /bin/bash
a=1
while [ $a -lt 100 ]
do
let a=a+1
echo $a
done
