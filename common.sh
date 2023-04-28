app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_print_head() {
  echo -e "\e[35m>>>>>>>> $1 <<<<<<<<\e[0m"
}

func_schema_setup() {
if [ "$schema_setup" == "mango" ]; then
  func_print_head "copy mongodb repo"
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo


  func_print_head "install mongodb client"
  yum install mongodb-org-shell -y

  func_print_head "load schema"
  mongo --host mongodb-dev.devjsr99.online </app/schema/${component}.js
fi
if  [ "${schema_setup}" == "mysql" ]; then

  func_print_head "install mysql client"
  yum install mysql -y

  func_print_head "load schema"
  mysql -h mysql-dev.devjsr99.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql

fi
}

func_app_prereq() {
   func_print_head "create app user"
    useradd ${app_user}

    func_print_head "create app Directory"
    rm -rf /app
    mkdir /app

    func_print_head "download application content"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/{component}.zip

    func_print_head "extract app content"
    cd /app
    unzip /tmp/${component}.zip

}

func_systemd_setup() {
   func_print_head "setup systemD service"
    cp ${script_path}/${component}.service /etc/systemd/system/{component}.service

    func_print_head "start shipping service"
    systemctl daemon-reload
    systemctl enable ${component}
    systemctl restart ${component}
}
func_nodejs() {
  func_print_head "configure nodeJS repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  func_print_head "install nodeJS"
  yum install nodejs -y

  func_app_prereq

  func_print_head "install nodeJS dependencies"
  npm install

  func_schema_setup
  func_systemd_setup
}
func_java() {
  func_print_head "install maven"
  yum install maven -y

  func_app_prereq

  func_print_head "download maven dependencies"
  mvn clean package
  mv target/${component}-1.0.jar ${component}.jar

  func_schema_setup
  func_systemd_setup
}