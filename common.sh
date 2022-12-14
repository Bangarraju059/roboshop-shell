# this script is only for DRY.

 StatusCheck() {
   if [ $? -eq 0 ]
    then
      echo -e "\e[32mSUCCESS\e[0m"
     else
       echo -e "\e[31mFAILURE\e[0m"
       exit 1
       fi
 }

 DOWNLOAD() {
   echo Downloading ${COMPONENT} Application content
   curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" >>${LOG}
   StatusCheck
 }

 APP_USER_SETUP() {
   id roboshop &>>${LOG}
       if [ $? -ne 0 ]; then
         echo Adding Applicatyion user
         useradd roboshop &>>${LOG}
         StatusCheck
       fi
 }
 APP_CLEAN() {
    echo Cleaning old application content
      cd /home/roboshop &>>${LOG} && rm -rf ${COMPONENT} &>>${LOG}
      StatusCheck

      echo Extracting Application archive
      unzip -o /tmp/${COMPONENT}.zip &>>${LOG}
      mv ${COMPONENT}-main ${COMPONENT} &>>${LOG}
      cd ${COMPONENT} &>>${LOG}
      StatusCheck
 }
SYSTEMD() {
  echo Configuring card systemD service
      mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG}
      StatusCheck

      echo Starting ${COMPONENT} Service
      systemctl daemon-reload &>>${LOG} && systemctl start ${COMPONENT} &>>${LOG} && systemctl enable ${COMPONENT} &>>${LOG}
      StatusCheck
}

 NODEJS() {
   echo Setting NodeJS repos
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
    StatusCheck

    echo Installing NodeJS
    yum install nodejs -y &>>${LOG}
    StatusCheck
    APP_USER_SETUP

    DOWNLOAD
    APP_CLEAN


   echo Installing NodeJS dependencies
   npm install &>>${LOG}
   StatusCheck
    SYSTEMD

 }

 JAVA() {
echo Install Maven
yum install maven -y &>>${LOG}
StatusCheck

APP_USER_SETUP
DOWNLOAD
APP_CLEAN

echo Make application package
mvn clean package &>>${LOG} && mv target/shipping-1.0.jar shipping.jar &>>${LOG}
StatusCheck

 SYSTEMD
 }

 PYTHON() {
   echo Install Python
   yum install python36 gcc python3-devel -y &>>${LOG}
   StatusCheck

  APP_USER_SETUP
  DOWNLOAD
  APP_CLEAN

  echo Install Python dependencies
    cd /home/roboshop/payment && pip3 install -r requirements.txt &>>${LOG}
    StatusCheck

  SYSTEMD
 }

 USER_ID=$(id -u)
 if [ $USER_ID -ne 0 ]; then
   echo -e "\e[31m You should run this script as root user or sudo  \e[0m"
   exit 1
   fi
LOG=/tmp/${COMPONENT}.log
rm -f ${LOG}