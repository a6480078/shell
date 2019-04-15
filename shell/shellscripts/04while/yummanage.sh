#!/bin/bash
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
echo "* 9. Search            *"
echo "************************"
echo "请输入号码:"
select number in "Create Yum Source" "Modify Yum Source" "Mount CDROM" "Eject CD" "Search Softs" "Install Softs" "Remove Softs" "Exit" "Search"
do
case $number in 

"Create Yum Source")
    echo -n "请输入yum源文件名称:  （以.repo结尾）"
    read filename
    touch /etc/yum.repos.d/$filename
    echo -n "请输入yum源的名称:"
    read yumname
    echo [$yumname] >> /etc/yum.repos.d/$filename
    echo -n "请输入yum源的描述:"
    read miaoshu
    echo "name=$miaoshu" >> /etc/yum.repos.d/$filename
    echo "请指定yum源:     (/mnt/cdrom)"
    read dizhi  
    echo "baseurl=file:///$dizhi" >> /etc/yum.repos.d/$filename
    echo "是否启用此源    yes or no" 
    read yum 
       if [ $yum = yes ] 
       then 
       echo "enabled=1" >> /etc/yum.repos.d/$filename 
       else
       rm -rf /etc/yum.repos.d/$filename
       break
       fi 
    echo "是否采用GPG密钥    yes or no"
    read miyao
        if [ $miyao = yes ]
        then 
        echo "gpgcheck=1" >> /etc/yum.repos.d/$filename
        else 
        echo "gpgcheck=0" >> /etc/yum.repos.d/$filename
        fi
    echo -n "GPG密钥的位置:   (没有写no)"
    read gpg
        if [ $gpg = no ] 
        then 
        echo "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release" >> /etc/yum.repos.d/$filename 
        else 
        echo "gpgkey=file://$gpg" >> /etc/yum.repos.d/$filename
        fi
    echo "Are you sure?    yes or no" 
    read xx
        if [ $xx = yes ]
        then
        echo "文件生效,按任意键退出" 
        read -s -n1
        else 
        echo -n "Are you sure?    yes or no"
        read xx
        fi
     clear
     continue;;
        
"Modify Yum Source")
      echo -n "请输入yum源文件名称:  （以.repo结尾）"
      read filename
      touch /etc/yum.repos.d/$filename
      echo -n "请输入yum源的名称:"
      read yumname
      echo [$yumname] > /etc/yum.repos.d/$filename
      echo -n "请输入yum源的描述:"
      read miaoshu
      echo "name=$miaoshu" >> /etc/yum.repos.d/$filename
      echo "请指定yum源:     (/mnt/cdrom)"
      read dizhi
      echo "baseurl=file:///$dizhi" >> /etc/yum.repos.d/$filename
      echo "是否启用此源    yes or no"
      read yum
           if [ $yum = yes ]
           then
           echo "enabled=1" >> /etc/yum.repos.d/$filename
           else
           rm -rf /etc/yum.repos.d/$filename
           break
           fi
      echo "是否采用GPG密钥    yes or no"
      read miyao
           if [ $miyao = yes ]
           then
           echo "gpgcheck=1" >> /etc/yum.repos.d/$filename
           else
           echo "gpgcheck=0" >> /etc/yum.repos.d/$filename
           fi
      echo -n "GPG密钥的位置:   (没有写no)"
      read gpg
           if [ $gpg = no ]
           then
           echo "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release" >>     /etc/yum.repos.d/$filename
           else
           echo "gpgkey=file://$gpg" >> /etc/yum.repos.d/$filename
           fi
      echo "Are you sure?    yes or no"
      read xx
           if [ $xx = yes ]
           then
           echo "文件生效,按任意键退出"
           read -s -n1
           else
           echo -n "Are you sure?    yes or no"
           read xx
           fi
       clear
       continue;;   

"Mount CDROM")
    echo "是否挂载/dev/cdrom  yes or no"
    read mount
    A=`mount | grep "/dev/cdrom" | awk '{print $5}'` 
    if [ $mount = yes ]
    then 
    mount /dev/cdrom /mnt/cdrom 
         if [ $A = iso9660 ] 
         then
         echo "挂载成功" 
         else
         echo "挂载失败" 
         fi 
    echo "按任意键退出"
    read -s -n1
    else
    clear
    continue  
    fi;; 

"Eject CD")
     echo "是否弹出光驱  yes or no"
     read eject 
     if [ $eject = yes ]
     then 
     eject
     echo "按任意键退出"
     read -s -n1
     else
     echo "按任意键退出"
     read -s -n1
     clear
     continue 
     fi;;

"Search Softs")
     echo -n "请输入软件名:" 
     read soft1 
     yum search $soft1
     echo "按任意键退出"
     read -s -n1
     clear
     continue;;

"Install Softs")
    echo -n "请输入软件名:"
    read soft2 
    yum install -y $soft2*
    echo "按任意键退出"
    read -s -n1
    clear
    continue;;

"Remove Softs")
    echo -n "请输入软件名:"
    read soft3
    yum remove -y $soft3 
    echo "按任意键退出"
    read -s -n1
    continue
    clear;;

"Exit") 
    echo " Bye :)"
    exit 0;;  

"Search")
    echo -n "请输入yum源文件名:"
    read filename
    cat /etc/yum.repos.d/$filename
    echo "按任意键退出"
    read -s -n1 
    continue
    clear;;
"*")
    continue;;
esac
break
done
done
