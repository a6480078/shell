#!/bin/bash
# /etc/rc.d/init.d/tomcat
# init script for tomcat precesses
# processname: tomcat
# chkconfig: 2345 86 16
# description: Start up the Tomcat servlet engine.

if [ -f /etc/init.d/functions ]; then
. /etc/init.d/functions
elif [ -f /etc/rc.d/init.d/functions ]; then
. /etc/rc.d/init.d/functions
else
echo -e "\atomcat: unable to locate functions lib. Cannot continue."
exit -1
fi
RETVAL=$?
CATALINA_HOME="/usr/local/tomcat8.5.35/"   #tomcat安装目录，你安装在什么目录下就复制什么目录

# start  
start(){  
echo -n "Starting Tomcat: "  
$CATALINA_HOME/bin/startup.sh  
echo  
}  
  
#stop  
stop(){  
echo -n "Shutting down Tomcat: "  
$CATALINA_HOME/bin/shutdown.sh  
}  
  
#restart  
restart(){  
stop  
sleep 3  
start  
}  
  
#status  
status(){  
ps ax --width=1000 | grep "[o]rg.apache.catalina.startup.Bootstrap start" | awk '{printf $1 " "}' | wc | awk '{print $2}' > /tmp/tomcat_process_count.txt  
read line < /tmp/tomcat_process_count.txt  
if [ $line -gt 0 ]; then  
echo -n "tomcat ( pid "  
ps ax --width=1000 | grep "[o]rg.apache.catalina.startup.Bootstrap start" | awk '{printf $1 " "}'  
echo -n ") is running..."  
echo  
else  
echo "Tomcat is stopped"  
fi  
}

case "$1" in
start)
start ;;
stop)
stop ;;
restart)
stop
sleep 3
start ;;
status)
status ;;
*)
echo $"Usage: $0 {start|stop|restart|status}"
exit 1
;;
esac
exit $RETVAL
