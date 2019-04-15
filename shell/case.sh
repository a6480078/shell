#!/bin/bash

if test -z $1;then
	rental="Unknow vehicle"
elif [ -n $1 ];then
	rental=$1
fi

case $rental in
	car )
		echo "I love car"
		;;
	bike )
		echo "I got bike"
		;;
	* )
		echo haha
		;;
esac