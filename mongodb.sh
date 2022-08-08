# set -e

COMPONENT=mongodb
source common.sh

echo SetUp YUM Repo
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
StatusCheck

echo Installing MongoDB
yum install -y mongodb-org &>>${LOG}
StatusCheck

echo Update MongoDB Listen Address
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG}
StatusCheck
## Update the Listen config

echo Start MongoDB Service
systemctl enable mongod &>>${LOG} && systemctl restart mongod &>>{LOG}
StatusCheck

DOWNLOAD

echo "Extract schema files"
cd /tmp && unzip -o mongodb.zip &>>${LOG}
StatusCheck

echo Load shema
cd mongodb-main && mongo < catalogue.js &>>{LOG} && mongo < users.js &>>{LOG}
StatusCheck
