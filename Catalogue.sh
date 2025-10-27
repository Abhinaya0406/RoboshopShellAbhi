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

VALIDATE $? "Disabling Current NodeJs" &>> $LOG_FILE

dnf module enable nodejs:18 -y

VALIDATE $? "Enabling NodeJs 18" &>> $LOG_FILE

dnf install nodejs -y

VALIDATE $? "Installing Node Js 18" &>> $LOG_FILE

useradd roboshop

VALIDATE $? "Creating Roboshop User" &>> $LOG_FILE

mkdir /app

VALIDATE $? "Creating AppDirectory" &>> $LOG_FILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

VALIDATE $? "Downloading Catalogue " &>> $LOG_FILE

cd /app 

unzip /tmp/catalogue.zip

VALIDATE $? "UnZipping Catalogue " &>> $LOG_FILE

npm install 

VALIDATE $? "Installing Dependencies" &>> $LOG_FILE

cp /home/centos/RoboshopShellAbhi/Catalogue.service /etc/systemd/system/catalogue.service

VALIDATE $? "Copied catalogue service file" &>> $LOG_FILE

systemctl daemon-reload

VALIDATE $? "Cdaemon reload complete" &>> $LOG_FILE

systemctl start catalogue

VALIDATE $? "started catalogue" &>> $LOG_FILE

cp /home/centos/RoboshopShellAbhi/mongo.repo  /etc/yum.repos.d/mongo.repo

VALIDATE $? "copying mongo repo" &>> $LOG_FILE

dnf install mongodb-org-shell -y

VALIDATE $? "Installed mongo repo" &>> $LOG_FILE

mongo --host mongodb.laddu.shop </app/schema/catalogue.js

VALIDATE $? "loading catalogue schema to mongodb" &>> $LOG_FILE


