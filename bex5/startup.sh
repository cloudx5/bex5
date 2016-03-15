#!/bin/sh

cd `dirname $0`
HOME=$PWD

echo "当前 HOME 目录：" $HOME

echo "正在更新 ‘model’"
rm -rf $HOME/model/*
mv -f /mnt/mesos/sandbox/model/* $HOME/model

echo `ll model`
echo ""

cd $HOME/mysql/bin
./startup.sh &
echo "MySQL 服务启动完毕..."
echo ""

sleep 10

echo "正在初始化 SQL 脚本"
for file in `ls /mnt/mesos/sandbox/sql`; do
  if [ -f /mnt/mesos/sandbox/sql/$file ]; then
    ./mysql --default-character-set=gbk -uroot -px5 x5sys < /mnt/mesos/sandbox/sql/$file
    echo $file " 初始化完毕..."
  fi
done
echo "SQL 脚本初始化完毕..."
echo ""

cd $HOME/apache-tomcat/bin
./startup.sh
echo "Tomcat 服务启动完毕..."

