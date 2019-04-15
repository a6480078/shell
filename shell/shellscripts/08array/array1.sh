#! /bin/bash
#通過declare -a命令可以將chuai作爲數組名稱
#可以通過chuai=(值1 值2 值3)來定義數組

chuai=(a b c d efg)

echo ${chuai[@]}
#將chuai這個數組作爲變量進行處理
#@符號表示第一個元素與*作用一樣
