#! /bin/bash
a=1
until [ $a -ge 100 ]
do
let a=a+1
echo $a
done
