#!/bin/bash

source components/common.sh

DOMAIN="zsldevops.online"

OS_PREREQ

Head "Installing Nginx"
apt install nginx -y &>>$LOG
systemctl restart nginx
Stat $?

Head "Install npm"
apt install npm -y &>>$LOG
Stat $?

Head "Update Nginx Configuration"
sed -i 's|/var/www/html|/var/www/html/vue/frontend/dist|g' /etc/nginx/sites-enabled/default
Stat $?

DOWNLOAD_COMPONENT

Head "Unzip Downloaded Archive"
cd /var/www/html &&rm -rf vue && mkdir vue && cd vue && unzip -o /tmp/frontend.zip &>>$LOG && rm -rf frontend.zip  && rm -rf frontend && mv frontend-main frontend && cd frontend
Stat $?

Head "update end points in service file"
cd /var/www/html/vue/frontend
export AUTH_API_ADDRESS=http://login.${DOMAIN}:8080
export TODOS_API_ADDRESS=http://todo.${DOMAIN}:8080
Stat $?

Head "update frontend configuration"
cd /var/www/html/vue/frontend  && sudo npm install --unsafe-perm sass sass-loader node-sass wepy-compiler-sass &>>$LOG && npm run build &>>$LOG
Stat $?

head "Start Npm service"
npm start
Stat $?