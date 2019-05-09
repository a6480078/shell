#!/bin/bash

for i in `seq 1 10`;do
{
sleep 3; echo 1 >> aa;echo done
} &
done
sleep 3
cat aa|wc -l
