#! /bin/bash
mount /dev/sdb1 /mnt/bak
mont=`mount | grep bak | cut -d " " -f 3`
if [ $mont = \/mnt\/bak ]
then
	cd /mnt/bak
	tar cfJ boot4backup-`date +%F`.txz /boot
	cd
	umount /mnt/bak
	echo "Work Over!"
else
echo "No Work!"
fi
