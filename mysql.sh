#!/bin/sh

########################Properties Begin########################
#MYSQL_NAME=mysql-5.7.21-linux-glibc2.12-x86_64
MYSQL_NAME=mysql-8.0.12-linux-glibc2.12-x86_64
workspace=`pwd`
########################Properties End########################

function clear(){
    MYSQL_PID=`ps -e | grep mysqld | awk '{print $1}'`
    if [ -n "$MYSQL_PID" ]; then
      kill -9 $MYSQL_PID
      echo "1.杀死MySQL进程成功："$MYSQL_PID
    else
      echo "1.没有存在的MySQL ^-^"
    fi
}

function install(){
    echo "2.清空"
    rm -rf ${workspace}/${MYSQL_NAME}
    if [ ! -f "${MYSQL_NAME}.tar.gz" ] && [ ! -f "${MYSQL_NAME}.tar.xz" ] && [ ! -f "${MYSQL_NAME}.tar" ]; then
      curl -O https://cdn.mysql.com//Downloads/MySQL-8.0/${MYSQL_NAME}.tar.xz
      echo "2.下载成功"
    else
      echo "2.已经存在，无需下载"
    fi

    echo "3.开始解压"
    #tar -zxf ${MYSQL_NAME}.tar.gz -C ${workspace}
    if [ -f "${MYSQL_NAME}.tar" ]; then
      tar -xf ${MYSQL_NAME}.tar -C ${workspace}
    elif [ -f "${MYSQL_NAME}.tar.xz" ]; then
      xz -d ${MYSQL_NAME}.tar.xz
      tar -xf ${MYSQL_NAME}.tar -C ${workspace}
    elif [ -f "${MYSQL_NAME}.tar.gz" ]; then
      tar -zxf ${MYSQL_NAME}.tar.gz -C ${workspace}
    fi
    echo "3.解压成功！"
}

function init(){
    # 4.初始化
    cp my.cnf ${workspace}/${MYSQL_NAME}
    sed -i -e "s:workspace_path:${workspace}:g" -e "s/mysql_name/${MYSQL_NAME}/g" ${workspace}/${MYSQL_NAME}/my.cnf
    INITIALIZE_CMD="${workspace}/${MYSQL_NAME}/bin/mysqld --defaults-file=${workspace}/${MYSQL_NAME}/my.cnf --initialize-insecure"
    echo "4.开始初始化"
    echo $INITIALIZE_CMD
    $INITIALIZE_CMD
    echo "4.初始化成功"

    echo "5.开始启动"
    START_CMD="${workspace}/${MYSQL_NAME}/bin/mysqld --defaults-file=${workspace}/${MYSQL_NAME}/my.cnf &"
    echo $START_CMD
    #$START_CMD

    ${workspace}/${MYSQL_NAME}/bin/mysqld --defaults-file=${workspace}/${MYSQL_NAME}/my.cnf &
    MYSQL_ALIVE_PID=`ps -e | grep mysqld | awk '{print $1}'`
    if [ -n "$MYSQL_ALIVE_PID" ]; then
      echo "5.启动成功："$MYSQL_ALIVE_PID
    else
      echo "5.启动失败 ^-^"
    fi

    echo "6.修改密码"
    PASSWD_CMD="${workspace}/${MYSQL_NAME}/bin/mysqladmin -uroot -p --socket=${workspace}/${MYSQL_NAME}/mysql.sock password 123456"
    echo $PASSWD_CMD
    #$PASSWD_CMD
    ${workspace}/${MYSQL_NAME}/bin/mysqladmin -uroot -p --socket=${workspace}/${MYSQL_NAME}/mysql.sock password 123456
    echo "6.修改密码成功"


    echo "7.开始授权"
    #for mysql5
    #GRANT_CMD="${workspace}/${MYSQL_NAME}/bin/mysql -uroot -p123456 --socket=${workspace}/${MYSQL_NAME}/mysql.sock -e \"GRANT ALL PRIVILEGES ON \*.\* TO 'root'@'%' IDENTIFIED BY '123456'\""
    #for mysql8
    CREATE_ROOT_CMD="${workspace}/${MYSQL_NAME}/bin/mysql -uroot -p123456 --socket=${workspace}/${MYSQL_NAME}/mysql.sock -e \"CREATE USER 'root'@'%' IDENTIFIED BY '123456'\""
    GRANT_CMD="${workspace}/${MYSQL_NAME}/bin/mysql -uroot -p123456 --socket=${workspace}/${MYSQL_NAME}/mysql.sock -e \"GRANT ALL PRIVILEGES ON \*.\* TO 'root'@'%' WITH GRANT OPTION\""
    echo $CREATE_ROOT_CMD
    echo $GRANT_CMD
    ${workspace}/${MYSQL_NAME}/bin/mysql -uroot -p123456 --socket=${workspace}/${MYSQL_NAME}/mysql.sock -e "CREATE USER 'root'@'%' IDENTIFIED BY '123456'"
    ${workspace}/${MYSQL_NAME}/bin/mysql -uroot -p123456 --socket=${workspace}/${MYSQL_NAME}/mysql.sock -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION"
    echo "7.授权成功"


    echo "8.开始重新加载权限表"
    PRIVILEGES_CMD="${workspace}/${MYSQL_NAME}/bin/mysql -uroot -p123456 --socket=${workspace}/${MYSQL_NAME}/mysql.sock -e \"FLUSH PRIVILEGES\""
    echo $PRIVILEGES_CMD
    #$PRIVILEGES_CMD

    ${workspace}/${MYSQL_NAME}/bin/mysql -uroot -p123456 --socket=${workspace}/${MYSQL_NAME}/mysql.sock -e "FLUSH PRIVILEGES"
    echo "8.重新加载权限表成功"


    echo "9.开始测试"
    VERSION_CMD="${workspace}/${MYSQL_NAME}/bin/mysql -uroot -p123456 --socket=${workspace}/${MYSQL_NAME}/mysql.sock -e \"SHOW VARIABLES WHERE Variable_name = 'version'\""
    echo $VERSION_CMD
    #$VERSION_CMD
    ${workspace}/${MYSQL_NAME}/bin/mysql -uroot -p123456 --socket=${workspace}/${MYSQL_NAME}/mysql.sock -e "SHOW VARIABLES WHERE Variable_name = 'version'"

    #PING_CMD="${workspace}/${MYSQL_NAME}/bin/mysqladmin --defaults-file=${workspace}/${MYSQL_NAME}/my.cnf"
    #echo $PING_CMD
    #$PING_CMD
    #${workspace}/${MYSQL_NAME}/bin/mysqladmin ping --socket=${workspace}/${MYSQL_NAME}/mysql.sock
    echo "9.测试成功"
}

function start(){
    ${workspace}/${MYSQL_NAME}/bin/mysqld --defaults-file=${workspace}/${MYSQL_NAME}/my.cnf &
    echo "Start successfully!\r\n"
    echo "==Use command below to continue:"
    echo ${workspace}"/"${MYSQL_NAME}"/bin/mysql -uroot -p123456 --socket="${workspace}"/"${MYSQL_NAME}"/mysql.sock"
    echo "==Use command below to create database"
    echo "create database *** default character set utf8 collate utf8_general_ci"
}

# 其他情况
function others(){
  echo " Usage: clear|install|init|start "
}

case "$1" in
  clear)
    clear
  ;;
  install)
    install
  ;;
  init)
    init
  ;;
  start)
    clear
    start
  ;;
  *)
    others
  ;;
esac
