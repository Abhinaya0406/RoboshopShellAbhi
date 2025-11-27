#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOG_FILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOG_FILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi # fi means reverse of if, indicating condition end

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