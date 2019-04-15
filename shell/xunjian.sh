#!/bin/bash
#
checkdate=`date +"%Y%m%d"`
#在各个服务器上执行的脚本，可以根据需求获取指定的数值及完整的信息

#设置一个标题函数，每次完整信息获取的时候可以调用，分割作用
function titledeal(){
	echo "+=====================$1==============+" >> /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt
}

#ip获取
#ipaddr=$1
ipaddr=`ip addr show eth0 |grep inet |grep eth0 |awk '{print $2}' |awk -F/ '{print $1}'`
mkdir /shell/$ipaddr-${checkdate}
echo $ipaddr > /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt


#user
username=`who|awk '{print $1}'`
titledeal username
echo $username >> /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt

#hostname
hostname=`hostname`
titledeal hostname
echo $hostname >> /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt

#操作系统版本
version=`head -n 1 /etc/issue`
titledeal version
echo $version >> /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt

#date
datetime=`date`
titledeal datetime
echo $datetime >> /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt

#磁盘使用，超过80%的显示出挂载点，如果不超过80%则显示正常Noraml
dfuse=`df -h |grep -v Filesystem |awk '{print $5,$6}'|awk -F% '$1>80 {print $1"% ",$2}' |awk '{printf $0","}'`	
#判断是否是空字符，如果是空字符则，意思是没有超过80%。所以显示为正常
if [[ -z $dfuse ]] ;then
	dfuse="Normal"
fi
titledeal diskuse
echo "diskuse(磁盘使用率) : " $dfuse >> /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt

#内存使用，使用量低于70%，显示正常，超过70%直接显示具体数值
freeuse=`free -m |grep Mem |awk '{print ($3/$2)*100}'`
if [[ $freeuse < 70 ]]; then
	freeuse="Normal"
else
	freeuse=$freeuse"%"
fi
titledeal memuse
echo "memuse(内存使用率) : " $freeuse >> /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt

#top，显示两个数值，一个是平均负载，一个是id的剩余情况
top -b -n 1 |head -6 > /shell/$ipaddr-use.txt
#id小于50则cpu的使用量显示，大于则显示正常
topcpu=`cat /shell/$ipaddr-use.txt |grep Cpu |awk -F, '{print $4}' |awk '$1<50 {print $1,$2}'`
#负载大于1显示，小于1则显示正常
loadaverage=`cat /shell/$ipaddr-use.txt  |head -1 |awk -F: '{print $NF}' |awk -F, '$1>1||$2>1||$3>1 {print $1,$2,$3}'`
if [[ -z $topcpu ]] ;then
	topcpu="Normal"
fi
if [[ -z $loadaverage ]] ;then
	loadaverage="Normal"
fi
titledeal topinfo
echo "topinfo : cpu load average（cpu平均负载） : " $loadaverage ,"cpuid : " $topcpu >> /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt

#uptime查看系统运行时间、用户数、负载
uptime=`uptime`
titledeal uptime"系统运行时间、用户数、负载"
echo $uptime >> /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt

#cpuinfo
cpuinfo=`cat /proc/cpuinfo |grep processor |wc -l`
titledeal cpuinfo
echo $cpuinfo >> /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt

#swaponinfo
swaponinfo=`swapon -s`
titledeal swaponinfo"所有交换分区"
echo $swaponinfo >> /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt

#cat /proc/loadavg查看系统负载
titledeal loadavg"系统负载"
cat /proc/loadavg >> /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt

#routeinfo
titledeal routeinfo"路由表"
route -n > /shell/$ipaddr-use.txt
cat /shell/$ipaddr-use.txt >> /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt

#mount
titledeal mountinfo"查看挂载的分区状态"
mount | column -t > /shell/$ipaddr-use.txt
cat /shell/$ipaddr-use.txt >> /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt

#完整的df -h的信息的获取
titledeal all-info-"磁盘"
df -h > /shell/$ipaddr-use.txt
cat /shell/$ipaddr-use.txt >> /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt
#完整的free -m的信息的获取
titledeal  all-info-"内存"
free -m > /shell/$ipaddr-use.txt
cat /shell/$ipaddr-use.txt >> /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt
#top的信息获取
top -b -n 1 |head -6 > /shell/$ipaddr-use.txt
titledeal top-all-info
cat /shell/$ipaddr-use.txt >> /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt

# netstat -lntp # 查看所有监听端口 
titledeal "监听端口"
netstat -lntp >> /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt

# netstat -antp # 查看所有已经建立的连接 
titledeal "已经建立的连接"
netstat -antp >>/shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt

# netstat -s # 查看网络统计信息 
netstat -s > /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}-netinfo.txt

#chkconfig --list

chkconfig --list > /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}-chkconfiglist.txt

echo "==============================================================">> /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt

#清理临时文件
rm -f /shell/$ipaddr-use.txt
chmod 777 /shell/$ipaddr-${checkdate}/$ipaddr-${checkdate}.txt

mkdir /data/info/${checkdate}
chmod 777 /data/info/${checkdate}
mv /shell/$ipaddr-${checkdate}/ /data/info/${checkdate}/

