#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M)
LOG_FILE="/tmp/$0_$TIMESTAMP.log"

if [ $ID -ne 0 ]
	then
		echo "Please try with root access"
		exit 1
	else
		echo "Root User"
fi


VALIDATE() {
	echo "validating $PACKAGE"
if [ $1 -ne 0 ]
	then
		echo "FAILED $2" 
	else
		echo "SUCCESS $2"
fi
}

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

dnf module enable redis:remi-6.2 -y

dnf install redis -y

systemctl enable redis

systemctl start redis