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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOG_FILE

VALIDATE $? "Copied Mongorepo" 

dnf install mongodb-org -y &>> $LOG_FILE

VALIDATE $? "Installed Mongorepo" 

systemctl enable mongod  &>> $LOG_FILE

VALIDATE $? "Enabled Mongorepo"

systemctl start mongod &>> $LOG_FILE

VALIDATE $? "Started Mongorepo" 

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOG_FILE

VALIDATE $? "updated 127 with 000 in mongo repo mongodb" 

systemctl restart mongod &>> $LOG_FILE

VALIDATE $? "Restarted mongodb" 


