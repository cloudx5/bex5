#!/bin/sh

cd `dirname $0`
HOME=$PWD

echo "当前 HOME 目录：$HOME"

echo "正在更新 ‘model’"
rm -rf $HOME/model/*
mv -f /mnt/mesos/sandbox/model/* $HOME/model

echo "`ll model`"
echo "model 更新完毕..."
echo ""

cd $HOME/mysql/bin
./startup.sh &
echo "MySQL 服务启动完毕..."
echo ""

sleep 10

mv -f /mnt/mesos/sandbox/sql $HOME

if [ -d $HOME/sql ]; then
echo "开始初始化 SQL 脚本"
cd $HOME/sql
$HOME/mysql/bin/mysql -uroot -px5 bex5
source ./00.init.sql;
exit

echo "SQL 脚本初始化完毕..."
echo ""
fi

echo "开始启动 Apache-tomcat 服务"
echo "正在配置服务启动参数..."
tmpstr="<version>`date +%d%M%S`</version>"
sed -i "s#<version>.*</version>#$tmpstr#g" $HOME/conf/server.xml
echo "正在启动 WEB 服务..."
cd $HOME/apache-tomcat/bin
./startup.sh
