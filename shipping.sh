echo -e "\e[36m>>>>>>>>install maven <<<<<\e[0m"
yum install maven -y

echo -e "\e[36m>>>>>>>>create app user <<<<<\e[0m"
useradd roboshop

rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>download app content <<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

echo -e "\e[36m>>>>>>>>extract app content<<<<<\e[0m"
cd /app
unzip /tmp/shipping.zip

echo -e "\e[36m>>>>>>>>download maven dependencies <<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[36m>>>>>>>>install mysql  <<<<<\e[0m"
yum install mysql -y

echo -e "\e[36m>>>>>>>>load schema<<<<<\e[0m"
mysql -h mysql-dev.devjsr99.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e "\e[36m>>>>>>>>setup systemD service<<<<<\e[0m"
cp /root/roboshop-shell/shipping.service /etc/systemd/system/shipping.service



echo -e "\e[36m>>>>>>>>start shipping service <<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping