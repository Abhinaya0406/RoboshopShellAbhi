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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOG_FILE

VALIDATE $? "installing remi release"

dnf module enable redis:remi-6.2 -y 

VALIDATE $? "enabling redis"

dnf install redis -y 

VALIDATE $? "instaling redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf

VALIDATE $? "remote connections redis" 

systemctl enable redis

VALIDATE $? "enable redis"

systemctl start redis 

VALIDATE $? "start redis"