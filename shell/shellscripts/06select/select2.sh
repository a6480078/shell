#! /bin/bash
#trap "" 2
while echo "按照以下提示操作:"
do
#echo "(1) 显示本地计算机IP地址"
#echo "(2) 编辑sudo"
#echo "(3) 显示CPU信息"
#echo "(4) 显示内存使用情况"
#echo "(5) 显示硬盘使用情况"
#echo "(6) 退出"
select number in "显示本地计算机IP地址" "编辑sudo" "显示CPU信息" "显示内存使用情况" "显示硬盘使用情况" "退出"
do
case $number in
"显示本地计算机IP地址")
	clear
	ifconfig eth0 | grep "inet addr:" | cut -d ":" -f 2 | cut -d " " -f 1
	read -s -n1
	continue;;
"编辑sudo")
	clear
	sudo visudo
	read -s -n1;;
"显示CPU信息")
	clear
	cat /proc/cpuinfo
	read -s -n1
	continue 2;;
"显示内存使用情况")
	clear
	free -m
	read -s -n1;;
"显示硬盘使用情况")
	clear
	df -Th
	read -s -n1;;
"退出")
	exit 0;;
*)
	continue;;
esac
break
done
done
