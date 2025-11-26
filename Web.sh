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

dnf install nginx -y

VALIDATE $? "Installed nginix file" &>> $LOG_FILE

systemctl enable nginx

VALIDATE $? "enabled nginix file" &>> $LOG_FILE

systemctl start nginx

VALIDATE $? "started nginix service" &>> $LOG_FILE

rm -rf /usr/share/nginx/html/*

VALIDATE $? "removed html" &>> $LOG_FILE

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

VALIDATE $? "downloaded web.zip to tmp" &>> $LOG_FILE

cd /usr/share/nginx/html

VALIDATE $? "downloaded web.zip to tmp" &>> $LOG_FILE

unzip /tmp/web.zip

vim /etc/nginx/default.d/roboshop.conf 

vim /etc/nginx/default.d/roboshop.conf 

systemctl restart nginx 