#!/bin/bash
i=0
while [[ $i -lt 255 ]]; do
    # i=`expr $i + 1`
    let i++
    /usr/bin/ping -c 2 -W 1 -i 0.5 192.168.1.$i &> /dev/null 
    if [[ $? -eq 0 ]]; then
        echo "192.168.1.$i is alive"
#    else
#        echo "192.168.1.$i is dead"
    fi
done
