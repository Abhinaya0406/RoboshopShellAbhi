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

dnf install nginx -y &>> $LOG_FILE

VALIDATE $? "Installed nginix file" 

systemctl enable nginx &>> $LOG_FILE

VALIDATE $? "enabled nginix file" 

systemctl start nginx &>> $LOG_FILE

VALIDATE $? "started nginix service" 

rm -rf /usr/share/nginx/html/* &>> $LOG_FILE

VALIDATE $? "removed html" 

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOG_FILE

VALIDATE $? "downloaded web.zip to tmp" 

cd /usr/share/nginx/html &>> $LOG_FILE

VALIDATE $? "html upadted" 

unzip /tmp/web.zip &>> $LOG_FILE

cp /home/centos/RoboshopShellAbhi/web.conf  /etc/nginx/default.d/roboshop.conf  

systemctl restart nginx &>> $LOG_FILE

VALIDATE $? "hnginx restarted"