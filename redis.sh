#set -e
source common.sh
COMPONENT=redis

echo Setup YUM Repo
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG}
StatusCheck

echo Install Redis
yum install redis-6.2.7 -y
StatusCheck

# update listen IP

echo Start Redis Server
systemctl enable redis &>>${LOG} && systemctl restart redis &>>${LOG}
StatusCheck