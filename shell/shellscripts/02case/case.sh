#! /bin/bash
echo "input a number(a-d):"
read number
case $number in
a|1)
	echo 1;;
b|2)
	echo 2;;
c)
	echo 3;;
d)	
	echo 4;;
*)
	echo "??";;
esac
