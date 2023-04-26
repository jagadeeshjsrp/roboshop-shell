echo -e "\e[36m>>>>>>>>configure nodeJS repos <<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[32m>>>>>>>>install  nodeJS <<<<<\e[0m"
yum install nodejs -y

echo -e "\e[33m>>>>>>>>add application user <<<<<\e[0m"
useradd roboshop
rm -rf /app
mkdir /app


echo -e "\e[33m>>>>>>>>downlaod app content <<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[35m>>>>>>>>unzip app content <<<<<\e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[36m>>>>>>>>install nodeJS dependencies<<<<\e[0m"
npm install

echo -e "\e[34m>>>>>>>>copy catalogue service file<<<<\e[0m"
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service


echo -e "\e[36m>>>>>>>>start catalogue service<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[36m>>>>>>>>copy mongodb repo<<<<\e[0m"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[33m>>>>>>>>install mongodb client<<<<\e[0m"
yum install mongodb-org-shell -y
mongo --host mongodb-dev.devjsr99.online </app/schema/catalogue.js