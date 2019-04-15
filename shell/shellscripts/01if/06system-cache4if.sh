#! /bin/bash
# /dev/sda3 Disk Use Check
sd3=`df -h /dev/sda3 | awk '{print $5}' | sed '1d' | cut -d "%" -f 1`
if [ $sd3 -gt 80 ]
then
	echo -e "Sda3 Disk Check \n`date` * `hostname` * <80% * /dev/sda3 DiskExceed:`expr $sd3 - 80`%" | mail -s root snow
fi

# /dev/sda1 Disk Use Check
sd1=`df -h /dev/sda3 | awk '{print $5}' | sed '1d' | cut -d "%" -f 1`
if [ $sd1 -gt 60 ]
then
	echo -e "Sda1 Disk Check \n`date` * `hostname` * <60%  * /dev/sda1 DiskExceed:`expr $sd1 - 60`%" | mail -s root snow
fi

# Swap Mem Use Check
swapuse=`free | grep Swap | awk '{print $3}'`
if [ $swapuse -gt 0 ]
then
	top5=`ps aux | sort -rn -k4 | head -5 | awk '{print $4,$11}'`
	echo -e "Swap Check \n`date` * `hostname` * <0 * Swap Use:$swapuse \nCurrent Process Top5: \n$top5" | mail -s root snow
fi

# Cpu idle Check
cpuidle=`iostat -c | sed -e '1,3d' | sed -e '2d' | awk '{print $6}' | cut -d . -f 1`
if [ $cpuidle -lt 30 ]
then
	top5=`ps aux | sort -rn -k3 | head -6  | awk '{print $3,$11}' | sed "/%CPU/d"`
	echo -e "CPU idel Check \n`date` * `hostname` * <30 * Cpu idle:$cpuidle \nCurrent Process Top5: \n$top5" | mail -s root snow
fi
