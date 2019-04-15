#!/bin/bash

for (( i=1; i<10; i+=1 ))
do
    useradd user$i && echo 12345 |passwd --stdin user$i
done
