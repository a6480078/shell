#!/bin/bash

function delete_file(){
local f=$1
local m="$0:file $1 faild to delete"
if [ -f $f ];then
rm -f $FILE && m="$0:$f file deleted."
else
m="$0:$f is not a file."
fi
dialog --title "Remove file" --clear --msgbox "$m" 10 50
}

FILE=$(dialog --title "Delete a file" --stdout --title "Please choose a file to delete" --fselect /tmp/ 14 48)

[ ! -z $FILE ] && delete_file "$FILE"
