#! /bin/bash
echo "Select a OS!"
select os in "RedHat" "Gentoo" "Archlinux" "Ubuntu" "Other";
do
break
done
echo "You Select is $os"
