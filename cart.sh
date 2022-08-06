#set -e

 echo Setting NodeJS repos
 curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/cart.log
 if [ $? -eq 0 ]
 then
   echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit 1
    fi

 echo Installing NodeJS
 yum install nodejs -y &>>/tmp/cart.log
 if [ $? -eq 0 ]
  then
    echo -e "\e[32mSUCCESS\e[0m"
   else
     echo -e "\e[31mFAILURE\e[0m"
     exit 1
     fi

 echo Adding Applicatyion user
 useradd roboshop &>>/tmp/cart.log
 if [ $? -eq 0 ]
  then
    echo -e "\e[32mSUCCESS\e[0m"
   else
     echo -e "\e[31mFAILURE\e[0m"
     exit 1
     fi

 echo Downloading Application content
 curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" >>/tmp/cart.log
 cd /home/roboshop &>>/tmp/cart.log
 if [ $? -eq 0 ]
  then
    echo -e "\e[32mSUCCESS\e[0m"
   else
     echo -e "\e[31mFAILURE\e[0m"
     exit 1
     fi

 echo Cleaning old application content
 rm -rf cart &>>/tmp/cart.log
 if [ $? -eq 0 ]
  then
    echo -e "\e[32mSUCCESS\e[0m"
   else
     echo -e "\e[31mFAILURE\e[0m"
     exit 1
     fi

 echo Extracting Application archive
 unzip -o /tmp/cart.zip &>>/tmp/cart.log
 mv cart-main cart &>>/tmp/cart.log
 cd cart &>>/tmp/cart.log
 if [ $? -eq 0 ]
  then
    echo -e "\e[32mSUCCESS\e[0m"
   else
     echo -e "\e[31mFAILURE\e[0m"
     exit 1
     fi

 echo Installing NodeJS dependencies
 npm install &>>/tmp/cart.log
 if [ $? -eq 0 ]
  then
    echo -e "\e[32mSUCCESS\e[0m"
   else
     echo -e "\e[31mFAILURE\e[0m"
     exit 1
     fi

echo Configuring card systemD service
 mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>/tmp/cart.log
 systemctl daemon-reload &>>/tmp/cart.log
 systemctl start cart &>>/tmp/cart.log
 systemctl enable cart &>>/tmp/cart.log
 if [ $? -eq 0 ]
  then
    echo -e "\e[32mSUCCESS\e[0m"
   else
     echo -e "\e[31mFAILURE\e[0m"
     exit 1
     fi