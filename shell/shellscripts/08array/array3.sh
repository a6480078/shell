#! /bin/bash
#顯示目前有值的數組序號
chuai=(a b c d ef)
for i in "${!chuai[@]}"
do
echo $i
done
