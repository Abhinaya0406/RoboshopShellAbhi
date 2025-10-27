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

cp mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "Copied Mongorepo" &>> LOG_FILE

dnf install mongodb-org -y 

VALIDATE $? "Installed Mongorepo" &>> LOG_FILE

systemctl enable mongod

VALIDATE $? "Enabled Mongorepo" &>> LOG_FILE

systemctl start mongod

VALIDATE $? "Started Mongorepo" &>> LOG_FILE

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> LOG_FILE

VALIDATE $? "Remote access to mongodb" &>> LOG_FILE

systemctl restart mongod

VALIDATE $? "Restarted mongodb" &>> LOG_FILE


