#set -e

 source common.sh
 COMPONENT=cart
 NODEJS



echo Configuring card systemD service
 mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>/tmp/cart.log

 echo Starting Cart Service
 systemctl daemon-reload &>>/tmp/cart.log
 systemctl start cart &>>/tmp/cart.log
 systemctl enable cart &>>/tmp/cart.log
 StatusCheck
