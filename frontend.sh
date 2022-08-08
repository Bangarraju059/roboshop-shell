#!/usr/bin/bash
#set -e
COMPONENT=frontend
source common.sh

echo Insatlling Nginx
yum install nginx -y &>>${LOG}
StatusCheck

DOWNLOAD

echo Cleaning old content
cd /usr/share/nginx/html && rm -rf *
StatusCheck

echo Extract Downloaded content
unzip -o /tmp/frontend.zip &>>${LOG} && mv frontend-main/static/* . && mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
StatusCheck

echo Start Nginx
systemctl restart nginx &>>${LOG}  && systemctl enable nginx &>>${LOG}

