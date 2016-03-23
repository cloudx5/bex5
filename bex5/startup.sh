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

echo "开始初始化 SQL 脚本"

mv -f /mnt/mesos/sandbox/sql $HOME
echo "`ll $HOME/sql`"
echo ""

if [ -d $HOME/sql ]; then
for II in `ls $HOME/sql`; do
  ./mysql -uroot -px5 bex5 < $HOME/sql/$II
  echo "$II 初始化完成..."
done
fi
echo "SQL 脚本初始化完毕..."
echo ""

echo "开始启动 Apache-tomcat 服务"
echo "正在配置服务启动参数..."
tmpstr="<version>`date +%d%M%S`</version>"
sed -i "s#<version>.*</version>#$tmpstr#g" $HOME/conf/server.xml
echo "正在启动 WEB 服务..."
cd $HOME/apache-tomcat/bin
./startup.sh

