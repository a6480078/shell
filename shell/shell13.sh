#!/bin/bash
i=0
k=0
while [[ $i -lt 255 ]]; do
    # i=`expr $i + 1`
    let i++
#{
    /usr/bin/ping -c 1 -W 1 -i 0.3 36.111.164.$i &> /dev/null
    if [[ $? -eq 0 ]]; then
        echo "36.111.164.$i is alive" 
        let k++
        #continue
    #else
    #    echo "36.111.164.$i is dead"
    fi
#    if [[ $k -ne 0 ]];then
#    	echo $k
#	fi
#	k=0
#} &
done
wait
echo $k
