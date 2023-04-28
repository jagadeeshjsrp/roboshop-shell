app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head() {
  echo -e "\e[35m>>>>>>>> $1 <<<<<<<<\e[0m"
}

schema_setup() {
  echo -e "\e[36m>>>>>>>>copy mongodb repo<<<<\e[0m"
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo


  echo -e "\e[33m>>>>>>>>install mongodb client<<<<\e[0m"
  yum install mongodb-org-shell -y

  echo -e "\e[34m>>>>>>>>load schema<<<<\e[0m"
  mongo --host mongodb-dev.devjsr99.online </app/schema/user.js
}

func_nodejs() {

  print_head "configure nodeJS repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  print_head "install nodeJS"
  yum install nodejs -y

  print_head "add application user"
  useradd ${app_user}
  rm -rf /app
  mkdir /app


  print_head "download app contenet"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  print_head "unzip app content"
  unzip /tmp/${component}.zip

  print_head "install dependencies"
  npm install

  print_head "copy cart service"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  print_head "start cart service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

  schema_setup

}