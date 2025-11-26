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
dnf module enable nodejs:18 -y

dnf install nodejs -y

useradd roboshop

mkdir /app

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip

cd /app 

unzip /tmp/cart.zip

unzip /tmp/cart.zip

npm install 

vim /etc/systemd/system/cart.service

systemctl daemon-reload

systemctl enable cart 

systemctl start cart