# set -e

Source common.sh

COMPONENT=mongodb

echo SwetUp YUM Repo
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
StatusCheck

echo Installing MongoDB
yum install -y mongodb-org &>>${LOG}
StatusCheck

echo Start MongoDB Service
systemctl enable mongod &>>${LOG} && systemctl start mongod &>>{LOG}
StatusCheck

#systemctl restart mongod

## Update the Listen config

DOWNLOAD

echo "Extract schema files"
cd /tmp && unzip -o mongodb.zip &>>${LOG}
StatusCheck

echo Load shema
cd mongodb-main && mongo < catalogue.js &>>{LOG} && mongo < users.js &>>{LOG}
StatusCheck
