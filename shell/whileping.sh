#!/bin/bash
i=1
while [[ $i -lt 255 ]]; do
{
    # i=`expr $i + 1`
#    let i++
    /usr/bin/ping -c 2 -W 1 -i 0.5 36.111.164.$i &> /dev/null 
    if [[ $? -eq 0 ]]; then
        echo "36.111.164.$i is alive"
#    else
#        echo "36.111.164.$i is dead"
    fi
} &
let i++
done
wait
