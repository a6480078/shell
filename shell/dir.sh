#!/bin/bash
 
#开始时间
begin=$(date +%s)
 
#测试根目录
root_dir="/home/wzy/wzy_scripts/file_scripts/test"
 
if [ ! -d $root_dir ]; then
	mkdir -p $root_dir
fi
cd $root_dir
 
#批量创建目录函数
function create_dir()
{
 
	mkdir $1
}
 
#循环创建10000个目录
count=10000
rsnum=200
cishu=$(expr $count / $rsnum)
 
for ((i=0; i<$cishu;))
do
	start_num=$(expr $i \* $rsnum + $i)
	end_num=$(expr $start_num + $rsnum)
	for j in `seq $start_num $end_num`
	do
		create_dir $j &
	done
	wait
	i=$(expr $i + 1)
done
 
#结束时间
end=$(date +%s)
spend=$(expr $end - $begin)
echo "花费时间为$spend秒"
