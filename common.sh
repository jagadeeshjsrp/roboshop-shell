app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log
# rm -f $log_file


func_print_head() {
  echo -e "\e[35m>>>>>>>> $1 <<<<<<<<\e[0m"
  echo -e "\e[35m>>>>>>>> $1 <<<<<<<<\e[0m" &>>$log_file
}

func_stat_check() {
  if [ $? -eq 0 ]; then
        echo -e "\e[32mSUCCES\e[0m"
  else
        echo -e "\e[32mFAILURE\e[0m"
        echo "Refer the log file /tmp/roboshop.log for more information"
        exit 1
  fi
}
func_schema_setup() {
if [ "$schema_setup" == "mango" ]; then
  func_print_head "copy mongodb repo"
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
  func_stat_check $?


  func_print_head "install mongodb client"
  yum install mongodb-org-shell -y &>>$log_file
  func_stat_check $?

  func_print_head "load schema"
  mongo --host mongodb-dev.devjsr99.online </app/schema/${component}.js
  func_stat_check $?
fi
if  [ "${schema_setup}" == "mysql" ]; then

  func_print_head "install mysql client"
  yum install mysql -y &>>$log_file
  func_stat_check $?

  func_print_head "load schema"
  mysql -h mysql-dev.devjsr99.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql
  func_stat_check $?
fi
}

func_app_prereq() {
   func_print_head "create app user"
   id ${app_user} &>>/tmp/roboshop.log
   if [ $? -ne 0 ]; then
    useradd ${app_user} &>>/tmp/roboshop.log
   fi
    func_stat_check $?

    func_print_head "create app Directory"
    rm -rf /app &>>$log_file
    mkdir /app &>>$log_file
    func_stat_check $?

    func_print_head "download application content"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
    func_stat_check $?

    func_print_head "extract app content"
    cd /app
    unzip /tmp/${component}.zip  &>>$log_file
    func_stat_check $?
}

func_systemd_setup() {
   func_print_head "setup systemD service"
    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
    func_stat_check $?

    func_print_head "start shipping service"
    systemctl daemon-reload &>>$log_file
    systemctl enable ${component} &>>$log_file
    systemctl restart ${component} &>>$log_file
    func_stat_check $?
}
func_nodejs() {
  func_print_head "configure nodeJS repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
  func_stat_check $?

  func_print_head "install nodeJS"
  yum install nodejs -y &>>$log_file
  func_stat_check $?

  func_app_prereq

  func_print_head "install nodeJS dependencies"
  npm install &>>$log_file
  func_stat_check $?

  func_schema_setup
  func_systemd_setup
}
func_java() {
  func_print_head "install maven"
  yum install maven -y  &>>$log_file
  func_stat_check $?
  func_app_prereq

  func_print_head "download maven dependencies"
  mvn clean package &>>$log_file
  func_stat_check $?
  mv target/${component}-1.0.jar ${component}.jar &>>$log_file

  func_schema_setup
  func_systemd_setup
}

func_python() {
  func_print_head "install python"
  yum install python36 gcc python3-devel -y &>>$log_file
  func_stat_check $?

  func_app_prereq

  func_print_head "install dependencies"
  pip3.6 install -r requirements.txt &>>$log_file
  func_stat_check $?

  func_print_head "update passwords in system service file"
  sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/payment.service &>>$log_file
  func_stat_check $?

  func_schema_setup

}