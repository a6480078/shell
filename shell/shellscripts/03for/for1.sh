#! /bin/bash
for (( i=0; i<101; i++)); do
if [ `expr $i % 3` -eq 0 ]
then
echo $i
continue
fi
done
