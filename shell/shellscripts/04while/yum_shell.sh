#! /bin/bash
trap "" 2
clear
while true
do
echo "************************"
echo "* 1. Create Yum Source *"
echo "* 2. Modify Yum Source *"
echo "* 3. Mount CDROM       *"
echo "* 4. Eject CD          *"
echo "* 5. Search Softs      *"
echo "* 6. Install Softs     *"
echo "* 7. Remove Softs      *"
echo "* 8. Exit              *"
echo "************************"
echo -n "Select a Number:"
read number
	if [ $number = 1 ]
	then
	clear
	echo "请输入yum文件名称：(以.repo结尾）"
	read yumname
	touch $yumname.repo
	echo "请输入yum源名称："
	read sourcename 
	echo "[$sourcename]" > $yumname.repo
	echo "请输入源的描述："
	read comment
	echo "name=$comment" >> $yumname.repo
	echo "请输入指定yum源的路径：/mnt/cdrom"
	read sourcedir
	echo "baseurl=file://$sourcedir" >> $yumname.repo
	echo "您是否启用此yum源？"
	echo "1 启用"
	echo "0 不启用"
	echo "请按回车键确认"
	read chosenum
	if [ $chosenum = 1 ]
	then 
	echo "enabled=1" >> $yumname.repo
	fi
	if [ $chosenum = 0 ]
	then
	echo "enabled=0" >> $yumname.repo
	fi
	echo "您是否采用GPG秘钥？"
	echo "确定请按y，不使用请按回车继续"
	read chosegpg
	if [ "$chosegpg" = "y" ]
	then
	echo "请输入GPG秘钥的路径："
	read gpgdir
	echo "gpgcheck=1" >> $yumname.repo
	echo "gpgkey=file://$gpgdir" >> $yumname.repo
	else
	echo "gpgcheck=0" >> $yumname >>$yumname.repo
	fi
	echo "yum源文件配置完成"
	echo "如果放弃请按n回车退出，如果确定请直接按回车保存文件并返回主菜单"
	read yesorno
	if [ "$yesorno" = "n" ]
	then
	rm -rf $yumname.repo
	clear
	continue
	else
	cp $yumname.repo /etc/yum.repos.d
	clear
	continue
	fi
	#read -s -n1
	fi
	if [ $number = 2 ]
	then
        clear
        echo "请输入yum文件名称："
        read yumname
        echo "请输入yum源名称："
        read sourcename
        echo "[$sourcename]" > $yumname.repo
        echo "请输入源的描述："
        read comment
        echo "name=$comment" >> $yumname.repo
        echo "请输入指定yum源的路径：/mnt/cdrom"
        read sourcedir
        echo "baseurl=file://$sourcedir" >> $yumname.repo
        echo "您是否启用此yum源？"
        echo "1 启用"
        echo "0 不启用"
        echo "请按回车键确认"
        read chosenum1
        if [ $chosenum1 = 1 ]
	then
        echo "enabled=1" >> $yumname.repo
        fi
        if [ $chosenum1 = 0 ]
        then
        echo "enabled=0" >> $yumname.repo
        fi
        echo "您是否采用GPG秘钥？"
        echo "确定请按y，不使用请按回车继续"
        read chosegpg
        if [ "$chosegpg" = "y" ]
        then
        echo "请输入GPG秘钥的路径："
        read gpgdir
        echo "gpgcheck=1" >> $yumname.repo
        echo "gpgkey=file://$gpgdir" >> $yumname.repo
        else
        echo "gpgcheck=0" >> $yumname >>$yumname.repo
        fi
        echo "yum源文件配置完成"
        echo "如果放弃请按n回车退出，如果确定请直接按回车保存文件并返回主菜单"
        read yesorno
	if [ "$yesorno" = "n" ]
        then
        clear
        continue
        else
        cp $yumname.repo /etc/yum.repos.d
        clear
        continue
        fi
	fi
	if [ $number = 3 ]
	then
	clear
	echo "是否挂载光盘？挂载请按y，否则按回车返回菜单。"
	read yesno
	if [ "$yesno" = "y" ]
	then
	mount /dev/cdrom /mnt/cdrom
	if [ -d "/mnt/cdrom/Packages" ]
	then
	clear
	echo "光盘已挂载，按任意键返回菜单"
	read -s -n1
	clear
	continue
	else
	clear
	echo "光盘挂载失败，按任意键返回菜单"
	read -s -n1
	clear
	continue
	fi
	else
	clear
	continue
	fi
	fi
	if [ $number = 4 ]
	then
	clear
        echo "是否弹出光盘？确认请按y，否则按回车返回菜单。"
        read yesno
        if [ "$yesno" = "y" ]
        then
        umount /mnt/cdrom
        if [ -d "/mnt/cdrom/Packages" ]
        then
        clear
        echo "光盘弹出失败，按任意键返回菜单"
        read -s -n1
        clear
        continue
        else
        clear
        echo "光盘弹出成功，按任意键返回菜单"
        read -s -n1
        clear
        continue
        fi
        else
	clear
	continue
        fi
	fi
	if [ $number = 5 ]
	then
	clear
	echo "请输入需要查询的软件名："
	read search
	yum search $search
	echo "请按任意键返回菜单："
	read -s -n1
	fi
 	if [ $number = 6 ]
        then
        clear
        echo "请输入需要安装的软件名："
        read instal
        yum install $instal
        echo "请按任意键返回菜单："
        read -s -n1
        fi
        if [ $number = 7 ]
        then
        clear
        echo "请输入需要删除的软件名："
        read remove
        yum remove $remove
        echo "请按任意键返回菜单："
        read -s -n1
        fi
        if [ $number = 8 ]
        then
        clear
        break
	else
	clear
	continue
	fi

done
