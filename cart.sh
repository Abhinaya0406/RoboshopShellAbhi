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

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip  &>> $LOG_FILE

VALIDATE $? "downloading cart application" 

cd /app  &>> $LOG_FILE

unzip /tmp/cart.zip  &>> $LOG_FILE

VALIDATE $? "unzipping cart application" 

npm install  &>> $LOG_FILE

VALIDATE $? "installing dependencies" 

cp /home/centos/RoboshopShellAbhi/cart.service /etc/systemd/system/cart.service  &>> $LOG_FILE

VALIDATE $? "copied dependenservce" 

systemctl daemon-reload  &>> $LOG_FILE

VALIDATE $? "daemon reloaded" 

systemctl enable cart   &>> $LOG_FILE

VALIDATE $? "enabled cart" 

systemctl start cart  &>> $LOG_FILE

VALIDATE $? "started  cart" 