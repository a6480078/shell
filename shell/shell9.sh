#!/bin/bash
while true; do
	read -p "account:" account
	read -p "password:" password
	if [[ $account = '' ]]; then
		continue
	elif [[ $password = '' ]]; then
		password=123456
	fi
	useradd $account && echo $password|passwd --stdin $account
	break
done

