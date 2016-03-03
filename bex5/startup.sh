#!/bin/sh

cd `dirname $0`
HOME=$PWD
cd $HOME/mysql/bin
./startup.sh &
sleep 10
cd $HOME/mysql/bin
cd $HOME/apache-tomcat/bin
./startup.sh

