#!/bin/bash

z=0
for (( i = 1; i < 101; i++ )); do
	# z=`expr $z + $i`
	z=$[z+i]
done
echo $z