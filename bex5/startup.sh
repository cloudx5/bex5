#!/bin/sh

cd `dirname $0`
HOME=$PWD
SRC_PATH="/mnt/mesos/sandbox"

echo "当前目录路径为[HOME]：$HOME"

if [ -d "$SRC_PATH/model" ];then
  echo "正在更新 model..."
  rm -rf $HOME/model
  mv -f $SRC_PATH/model $HOME

  echo "model 更新完毕"
  echo ""
else
  echo "APP 源码不完整，无法启动"
  echo "正在结束..."
  exit 0
fi

if [ -d "$SRC_PATH/doc" ];then
  echo "正在更新 doc..."
  rm -rf $HOME/data/doc
  mv -f $SRC_PATH/doc $HOME/data

  echo "doc 更新完毕"
  echo ""
fi

cd $HOME/mysql/bin
./startup.sh &

echo "MySQL 服务启动完毕"
echo ""

sleep 10

begin_time=$(date "+%s")
load_script(){
  for file_name in `ls -A $1`;do
    start_time=$(date "+%s")
    if [ -s "$1/$file_name" ];then
      ./mysql -uroot -px5 bex5 -e "source $1/$file_name"
      echo "source:" \"$1/$file_name\" "导入成功, 用时：" `expr $(date "+%s") - ${start_time}` " 秒"
    fi
  done

  echo "SQL 脚本全部导入完毕! 共计用时: " `expr $(date "+%s") - ${begin_time}` " 秒"
}

file_path="$SRC_PATH/sql"
file_list=`ls -A $file_path`
if [ "$file_list" ];then
  echo "开始初始化 SQL 脚本..."
  load_script $file_path
fi

echo "开始启动 Apache-tomcat 服务"
echo "正在配置服务启动参数..."
tmpstr="<version>`date +%d%M%S`</version>"
sed -i "s#<version>.*</version>#$tmpstr#g" $HOME/conf/server.xml
echo "正在启动 WEB 服务..."
cd $HOME/apache-tomcat/bin
./startup.sh
