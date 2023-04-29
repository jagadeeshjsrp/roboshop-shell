script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "Install Nginx"
yum install nginx -y
func_stat_check $?

func_print_head "Copy Roboshop Config File"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf
func_stat_check $?

func_print_head "Clean Old App Content"
rm -rf /usr/share/nginx/html/*
func_stat_check $?

func_print_head "Download App Contnt"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
func_stat_check $?

func_print_head "Extracting App Content"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
func_stat_check $?

func_print_head "Start Nginx service"
systemctl restart nginx
systemctl enable nginx
func_stat_check $?
