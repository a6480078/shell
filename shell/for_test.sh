#!/bin/bash

#LIST=(~/.config/*)
#for var in "${LIST[*]}";do
#    printf "%3s\n" ${var}
#done

#for command in date pwd df;do
#    echo
#    echo "The output of ${command} command >"
#    $command
#    echo
#done


[ $# -eq 0 ] && { echo "Usage:bash $0 file1 file2 file3";exit 1; }
for f in $*;do
echo
echo "<$f>"
[ -f $f ]&&cat $f||echo "$f not found"
echo '---------------------------'
done
