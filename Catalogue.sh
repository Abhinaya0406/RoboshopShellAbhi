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

dnf module disable nodejs -y &>> $LOG_FILE

VALIDATE $? "Disabling Current NodeJs" 

dnf module enable nodejs:18 -y &>> $LOG_FILE

VALIDATE $? "Enabling NodeJs 18" 

dnf install nodejs -y &>> $LOG_FILE

VALIDATE $? "Installing Node Js 18" 

useradd roboshop &>> $LOG_FILE

VALIDATE $? "Creating Roboshop User" 

mkdir /app &>> $LOG_FILE

VALIDATE $? "Creating AppDirectory" 

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip  &>> $LOG_FILE

VALIDATE $? "Downloading Catalogue application"

cd /app &>> $LOG_FILE

unzip /tmp/catalogue.zip &>> $LOG_FILE

VALIDATE $? "UnZipping Catalogue " 

npm install &>> $LOG_FILE

VALIDATE $? "Installing Dependencies" 

#use absolute path because catalogue.service exists there
cp /home/centos/RoboshopShellAbhi/Catalogue.service /etc/systemd/system/catalogue.service &>> $LOG_FILE

VALIDATE $? "Copied catalogue service file" 

systemctl daemon-reload &>> $LOG_FILE

VALIDATE $? "daemon reload complete" 

systemctl enable catalogue &>> $LOG_FILE

VALIDATE $? "enabled catalogue" 

systemctl start catalogue &>> $LOG_FILE

VALIDATE $? "started catalogue" 

cp /home/centos/RoboshopShellAbhi/mongo.repo  /etc/yum.repos.d/mongo.repo &>> $LOG_FILE

VALIDATE $? "copiedng mongo repo" 

dnf install mongodb-org-shell -y &>> $LOG_FILE

VALIDATE $? "Installed mongo db client" 

mongo --host mongodb.laddu.shop </app/schema/catalogue.js &>> $LOG_FILE

VALIDATE $? "loading catalogue schema to mongodb" 


