#!/bin/bash
sum=0
file=`ls -l /var/log/|awk '{print$NF}'`
for i in ${file}; do
	if [[ -d $i ]]; then
		dir=`ls -l /var/log/$i |wc -l`
		sum=$[sum+dir]
	else
		let sum++
	fi
done
echo ${sum}

#!/bin/bash 
#使用 ls 递归显示所有,再判断是否为文件,如果是文件则计数器加 1 
sum=0
vars=`ls -r /var/log/*`
for i in $vars
do
    if [[ ‐f $i ]];then 
        let sum++ 
        echo "文件名:$i" 
    fi 
done 
echo   "总文件数量为:$sum" 
