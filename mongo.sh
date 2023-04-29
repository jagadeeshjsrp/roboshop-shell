script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "Setup MangoDb repo"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_stat_check $?

func_print_head "Install MangoDb"
yum install mongodb-org -y &>>$log_file
func_stat_check $?

func_print_head "Update Mangodb listen address"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>$log_file
func_stat_check $?

func_print_head "Start MangoDb"
systemctl enable mongod &>>$log_file
systemctl restart mongod &>>$log_file
func_stat_check $?

#edit the file & replace 127.0.0.1 with 0.0.0.0

#systemctl restart mongodx