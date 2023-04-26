echo -e "\e[36m>>>>>>>>install golang<<<<<\e[0m"
yum install golang -y

echo -e "\e[36m>>>>>>>>add application user<<<<<\e[0m"
useradd roboshop
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>download app content<<<<<\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app

echo -e "\e[36m>>>>>>>>extract app content<<<<<\e[0m"
unzip /tmp/dispatch.zip
cd /app
go mod init dispatch
go get
go build

cp /home/centos/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service
echo -e "\e[36m>>>>>>>>start dispatch service<<<<<\e[0m"
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch