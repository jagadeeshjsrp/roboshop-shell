curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd roboshop
mkdir /app
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip
npm install
cp cart.service /etc/systemd/system/cart.service
systemctl daemon-reload
systemctl enable cart
systemctl start cart
