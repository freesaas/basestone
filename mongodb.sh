#!/bin/sh

########################Properties Begin########################
MONGODB_NAME=mongodb-linux-x86_64-rhel70-4.2.3
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
    rm -rf ${workspace}/${MONGODB_NAME}
    if [ ! -f "${MONGODB_NAME}.tar.gz" ] && [ ! -f "${MONGODB_NAME}.tar.xz" ] && [ ! -f "${MONGODB_NAME}.tar" ] && [ ! -f "${MONGODB_NAME}.tgz" ]; then
      curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-4.2.3.tgz
      echo "2.下载成功"
    else
      echo "2.已经存在，无需下载"
    fi

    echo "3.开始解压"
    #tar -zxf ${MONGODB_NAME}.tar.gz -C ${workspace}
    if [ -f "${MONGODB_NAME}.tar" ]; then
      tar -xf ${MONGODB_NAME}.tar -C ${workspace}
    elif [ -f "${MONGODB_NAME}.tgz" ]; then
      tar -zxf ${MONGODB_NAME}.tgz -C ${workspace}
    elif [ -f "${MONGODB_NAME}.tar.xz" ]; then
      xz -d ${MONGODB_NAME}.tar.xz
      tar -xf ${MONGODB_NAME}.tar -C ${workspace}
    elif [ -f "${MONGODB_NAME}.tar.gz" ]; then
      tar -zxf ${MONGODB_NAME}.tar.gz -C ${workspace}
    fi
    echo "3.解压成功！"
}

function init(){
    # 4.初始化
    echo "4.开始初始化"
    mkdir -p ${workspace}/${MONGODB_NAME}/mongodb_data
    echo "4.初始化成功"

}

function start(){


    echo "5.开始启动"
    START_CMD="${workspace}/${MONGODB_NAME}/bin/mongod --port 27017 --dbpath=${workspace}/${MONGODB_NAME}/mongodb_data &"
    echo $START_CMD

    ${workspace}/${MONGODB_NAME}/bin/mongod --bind_ip 0.0.0.0 --port 27017 --dbpath=${workspace}/${MONGODB_NAME}/mongodb_data &
    MONGODB_ALIVE_PID=`ps -e | grep mongod | awk '{print $1}'`
    if [ -n "$MONGODB_ALIVE_PID" ]; then
      echo "5.启动成功："$MONGODB_ALIVE_PID
    else
      echo "5.启动失败 ^-^"
    fi

    echo "Start successfully!\r\n"
    echo "==Use command below to continue:"
    echo "./mongo"
    echo "==Use command below to create database"
    echo "use admin"
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
