#! /bin/bash
echo -n "your disk used __% when you feel dangerous ?"
read n
	if [ $n -ge 100 ]
	then echo "your number is wrong" 
	else 
		r=`df -h|sed "1d"|cut -d"%" -f 1|awk '{print$5}'`
		echo $r
		read -s -n1
		for ri in $r 
		do
			if [ $ri -ge $n ] 
			then 
	 		d=`df -h|grep "$ri"|awk '{print$1}'|cut -d"/" -f3`
	  		echo -e `date`"\t"`hostname`"\t$d\tused\t$ri%,>$n%"
			echo -e "your disk:$d\tused\t$ri%,>$n%" 
       	    fi
		done
	fi
