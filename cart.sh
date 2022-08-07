#set -e

 source common.sh

 NODEJS

 echo Downloading Application content
 curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" >>/tmp/cart.log
 cd /home/roboshop &>>/tmp/cart.log
 StatusCheck

 echo Cleaning old application content
 rm -rf cart &>>/tmp/cart.log
 StatusCheck

 echo Extracting Application archive
 unzip -o /tmp/cart.zip &>>/tmp/cart.log
 mv cart-main cart &>>/tmp/cart.log
 cd cart &>>/tmp/cart.log
 StatusCheck

 echo Installing NodeJS dependencies
 npm install &>>/tmp/cart.log
 StatusCheck

echo Configuring card systemD service
 mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>/tmp/cart.log
 systemctl daemon-reload &>>/tmp/cart.log
 systemctl start cart &>>/tmp/cart.log
 systemctl enable cart &>>/tmp/cart.log
 StatusCheck
