#! /bin/bash
cp -Rp /etc /backup
cd /backup
tar cfJ etc.txz etc
rm -rf etc
pwd
ls --color
cd

