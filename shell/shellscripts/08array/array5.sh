#! /bin/bash
#將/etc/passwd的值賦值給變量i
for i in $(cut -f 1,3 -d: /etc/passwd)
do
echo $i
#匹配變量i的:後面的字符是否與確認第二位的值與$i值中的第一位是否一致
array[${i#*:}]=${i%:*}
done
echo "User ID $1 is ${array[$1]}."
echo "There are currently ${#array[@]} user accounts on the system."
