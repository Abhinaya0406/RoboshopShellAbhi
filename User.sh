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

VALIDATE $? "unistalled nodejs"

dnf module enable nodejs:18 -y &>> $LOG_FILE

VALIDATE $? "enabled nodejs"

dnf install nodejs -y &>> $LOG_FILE

VALIDATE $? "installed nodejs"

useradd roboshop &>> $LOG_FILE

VALIDATE $? "User craeted"

mkdir /app &>> $LOG_FILE

VALIDATE $? "dir craeted"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOG_FILE

VALIDATE $? "downloading application"

cd /app  &>> $LOG_FILE

unzip /tmp/user.zip &>> $LOG_FILE

VALIDATE $? "unzip application" 

npm install  &>> $LOG_FILE

VALIDATE $? "Installing dependencies"

cp  cp /home/centos/RoboshopShellAbhi/user.service /etc/systemd/system/user.service &>> $LOG_FILE

VALIDATE $? "copied service"

systemctl daemon-reload &>> $LOG_FILE

VALIDATE $? "daemon reloaded"

systemctl enable user  &>> $LOG_FILE

VALIDATE $? "user enabled"

systemctl start user &>> $LOG_FILE

VALIDATE $? "user started"

cp /home/centos/RoboshopShellAbhi/mongo.repo  /etc/yum.repos.d/mongo.repo &>> $LOG_FILE

VALIDATE $? "copiedng mongo repo" 

dnf install mongodb-org-shell -y &>> $LOG_FILE

VALIDATE $? "Installed mongo db client" 

mongo --host mongodb.laddu.shop </app/schema/catalogue.js &>> $LOG_FILE

VALIDATE $? "loading catalogue schema to mongodb" git