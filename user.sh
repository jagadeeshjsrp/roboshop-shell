script_path=$(dirname $0)
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>configure nodeJS repos <<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[32m>>>>>>>>install  nodeJS <<<<<\e[0m"
yum install nodejs -y

echo -e "\e[33m>>>>>>>>add application user <<<<<\e[0m"
useradd ${app_user}

rm -rf /app
mkdir /app

echo -e "\e[33m>>>>>>>>downlaod app content <<<<<\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app

echo -e "\e[35m>>>>>>>>unzip app content <<<<<\e[0m"
unzip /tmp/user.zip

echo -e "\e[36m>>>>>>>>install nodeJS dependencies<<<<\e[0m"
npm install
#haha
#haha

echo -e "\e[34m>>>>>>>>copy user service file<<<<\e[0m"
cp $script_path/user.service /etc/systemd/system/user.service

echo -e "\e[36m>>>>>>>>start user service<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl start user

echo -e "\e[36m>>>>>>>>copy mongodb repo<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo


echo -e "\e[33m>>>>>>>>install mongodb client<<<<\e[0m"
yum install mongodb-org-shell -y
mongo --host mongodb-dev.devjsr99.online </app/schema/user.js