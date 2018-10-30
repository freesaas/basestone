#!/bin/sh

workspace=`pwd`
MYSQL_NAME=mysql-5.7.21-linux-glibc2.12-x86_64

#清理
MYSQL_PID=`ps -e | grep mysqld | awk '{print $1}'`
if [ -n "$MYSQL_PID" ]; then
  kill -9 $MYSQL_PID
  echo "Kill mysql successfully: "$MYSQL_PID
else
  echo "There's no mysql exists ^-^"
fi

${workspace}/${MYSQL_NAME}/bin/mysqld --defaults-file=${workspace}/${MYSQL_NAME}/my.cnf &

echo "Start successfully!\r\n"

echo "==Use command below to continue:"
echo ${workspace}"/"${MYSQL_NAME}"/bin/mysql -uroot -p123456 --socket="${workspace}"/"${MYSQL_NAME}"/mysql.sock"
echo "==Use command below to create database"
echo "create database *** default character set utf8 collate utf8_general_ci"
