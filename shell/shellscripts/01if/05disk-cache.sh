use1=`df -h | sed '1d' | awk '{print $5}' | sed '2,$d' | cut -d "%" -f 1`
use2=`df -h | sed '1d' | awk '{print $5}' | sed '1d' | sed '2,$d' | cut -d "%" -f 1`
use3=`df -h | sed '1d' | awk '{print $5}' | sed '1,2d' | sed '2d' | cut -d "%" -f 1`
use4=`df -h | sed '1d' | awk '{print $5}' | sed '1,3d' | cut -d "%" -f 1`
disk1=`df -h | sed '1d' | awk '{print $1}' | sed '2,$d'`
disk2=`df -h | sed '1d' | awk '{print $1}' | sed '1d' | sed '2,$d'`
disk3=`df -h | sed '1d' | awk '{print $1}' | sed '1,2d' | sed '2d'`
disk4=`df -h | sed '1d' | awk '{print $1}' | sed '1,3d'`

if [ $use1 -ge 70 ]
then
	echo "$disk1:`date`" >> Diskuse.txt
elif [ $use2 -ge 70 ]
then
	echo "$disk2:`date`" >> Diskuse.txt
elif [ $use3 -ge 70 ]
then
	echo "$disk3:`date`" >> Diskuse.txt
elif [ $use4 -ge 70 ]
then
	echo "$disk3:`date`" >> Diskuse.txt
else
        echo 
fi
