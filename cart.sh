echo -e "\e[36m>>>>>>>>configure nodeJS repos <<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[33m>>>>>>>>install nodeJS  <<<<<\e[0m"
yum install nodejs -y

echo -e "\e[34m>>>>>>>>add application user <<<<<\e[0m"
useradd roboshop
rm -rf /app
mkdir /app

echo -e "\e[31m>>>>>>>>download app contenet <<<<<\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app

echo -e "\e[36m>>>>>>>>unzip app content <<<<<\e[0m"
unzip /tmp/cart.zip

echo -e "\e[36m>>>>>>>>install dependencies <<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>copy cart service  <<<<<\e[0m"
cp /root/roboshop-shell/cart.service /etc/systemd/system/cart.service

echo -e "\e[36m>>>>>>>>start cart service <<<<<\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl start cart
