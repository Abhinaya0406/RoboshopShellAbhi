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

dnf module disable nodejs -y

VALIDATE() ?! unistalled nodejs

dnf module enable nodejs:18 -y

VALIDATE() ?! installed nodejs

dnf install nodejs -y

useradd roboshop

mkdir /app

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip

cd /app 

unzip /tmp/user.zip

cd /app 

npm install 

vim /etc/systemd/system/user.service

systemctl daemon-reload

systemctl enable user 

systemctl start user


dnf install mongodb-org-shell -y

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/user.js