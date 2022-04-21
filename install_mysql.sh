#!/bin/bash

# Variables
DATE=`date +%s`
#LOG_FS="/home/ubuntu"
LOG_FS=$1
LOG_NAME="log_$DATE.log"
LOG_LOCATION="$LOG_FS/$LOG_NAME"
OS_RELEASE=`cat /etc/os-release | grep -w NAME | awk -F '=' '{print $2}' | tr -d \"`

# Main Program
echo "Identified OS: $OS_RELEASE" > $LOG_LOCATION 

# Check OS
if [[ $OS_RELEASE == "Ubuntu" ]]
then
	sudo apt install mysql-server -y >> $LOG_LOCATION
	STATUS=`service mysql status | grep Active | awk '{print $2}'`
	echo "====== MY STATUS IS: $STATUS =======" >> $LOG_LOCATION
        if [ $STATUS == "inactive" ]
	then
		sudo service mysql start >> $LOG_LOCATION
		service mysql status >> $LOG_LOCATION
		echo "===== MYSQL Service Started ====" >> $LOG_LOCATION
        fi
elif [[ $OS_RELEASE =~ "CentOS" ]]
then
	wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm >> $LOG_LOCATION
	sudo rpm -ivh mysql57-community-release-el7-9.noarch.rpm >> $LOG_LOCATION
	sudo yum -y install mysql-server >> $LOG_LOCATION
	STATUS=`service mysqld status | grep Active | awk '{print $2}'`
        echo "====== MY STATUS IS: $STATUS =======" >> $LOG_LOCATION
        if [ $STATUS == "inactive" ]
        then
                sudo service mysqld start >> $LOG_LOCATION
                service mysqld status >> $LOG_LOCATION
                echo "===== MYSQL Service Started ==== " >> $LOG_LOCATION
        fi	
else
	echo "Not my circus not my monkeys boss" >> $LOG_LOCATION
fi
