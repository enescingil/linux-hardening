#!/bin/bash
#Author: enestos

function password(){
	echo "Looking for files containing password, it can take sometime, it will be saved on password.txt"
	sleep 5
	touch password.txt
	grep --color=auto -rnw '/' -ie "PASSWORD" --color=always 2> /dev/null > password.txt

}

function edited_files(){
	echo "Looking for a edited files last 10 minutes, it will be saved on edited.txt"
	sleep 5
	touch edited.txt
	find / -mmin -10 2>/dev/null | grep -Ev "^/proc" > edited.txt

}

function sensitive(){
	echo "Looking for sensitive files, it will take sometime, you can find them at sensitive.txt"
	sleep 5
	touch sensitive.txt
	locate password | more > sensitive.txt

}

function ssh(){
	echo "Looking for SSH information, will be saved on ssh_info.txt"
	sleep 5
	touch ssh_info.txt
	find / -name authorized_keys 2> /dev/null&> ssh_info.txt
	find / -name id_rsa 2> /dev/null &>>ssh_info.txt

}

function crontab(){
	echo "[**]Looking for a cron jobs[**]"
	sleep 5
	sudo crontab -l
	sudo ls -alh /var/spool/cron
	sudo ls -al /etc/ | grep cron
	sudo ls -al /etc/cron*
	sudo cat /etc/cron*
	sudo cat /etc/at.allow
	sudo cat /etc/at.deny
	sudo cat /etc/cron.allow
	sudo cat /etc/cron.deny
}

function SUID(){
	echo "Looking for SUID binaries, saved on suid.txt"
	sleep 5
	touch suid.txt
	find / -perm -4000 -type f -exec ls -la {} 2>/dev/null \; &> suid.txt
	find / -uid 0 -perm -4000 -type f 2>/dev/null &>> suid.txt

}

function sudo(){
	echo "Looking for sudo permission files, saved on sudols.txt"
	sleep 3
	touch sudols.txt
	sudo -l &> sudols.txt

}

if [[ $EUID -ne 0 ]]; then
	echo "This script must run as a root" 1>&2
	exit 1
else
	password
	edited_files
	sensitive
	ssh
	crontab
	SUID
	sudo
fi
