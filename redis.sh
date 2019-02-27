#!/bin/sh

#3/4/5
VERSION=5
WORKSPACE=`pwd`
node=7000
if [ $VERSION == 5 ]; then
  VERSION_NAME=redis-5.0.3
elif [ $VERSION == 3 ]; then
  VERSION_NAME=redis-3.2.3
fi

function install(){
  if [ ! -f "${VERSION_NAME}.tar.gz" ]; then
    REDIS_URL=http://download.redis.io/releases/${VERSION_NAME}.tar.gz
    curl -O ${REDIS_URL}
  fi
  rm -rf ${VERSION_NAME} redis-dist

  tar -zxf ${VERSION_NAME}.tar.gz
  cd ${VERSION_NAME}
  #make PREFIX=/home/bes/sof/redis/redis-dist MALLOC=libc install 
  make PREFIX=/home/bes/sof/redis/redis-dist install
}

function clusterinit(){
  rm -rf dump.rdb
  for node in {7001..7006}
  do
    rm -rf redis-$node.conf nodes-$node.conf
    cp ${VERSION_NAME}/redis.conf redis-$node.conf
    sed -i "s/bind 127.0.0.1/bind 192.168.9.52/g" redis-$node.conf
    sed -i "s/6379/$node/g" redis-$node.conf
    sed -i "s/daemonize no/daemonize yes/g" redis-$node.conf
    sed -i "s/# cluster-enabled yes/cluster-enabled yes/g" redis-$node.conf
    sed -i "s/# cluster-config-file nodes-${node}.conf/cluster-config-file nodes-${node}.conf/g" redis-$node.conf
  done
}

function clusterstart(){
  ps -e | grep redis | awk '{print $1}' | xargs kill -9
  command=""
  for node in {7001..7006}
  do
    redis-dist/bin/redis-server redis-$node.conf &
    command=${command}" 192.168.9.52:"${node}
  done
  sleep 5
  redis-dist/bin/redis-cli --cluster create ${command} --cluster-replicas 1
}

function clusterstop(){
  ps -e | grep redis | awk '{print $1}' | xargs kill -9
  rm -rf dump.rdb
  for node in {7001..7006}
  do
    rm -rf redis-$node.conf nodes-$node.conf
  done
}

function singleinit(){
  
  rm -rf dump.rdb
  rm -rf redis-$node.conf
  cp ${VERSION_NAME}/redis.conf redis-$node.conf
  sed -i "s/bind 127.0.0.1/bind 192.168.9.52/g" redis-$node.conf
  sed -i "s/6379/$node/g" redis-$node.conf
  sed -i "s/daemonize no/daemonize yes/g" redis-$node.conf
}

function singlestart(){
  redis-dist/bin/redis-server redis-$node.conf &
}

# 其他情况
function others(){
  echo " Usage: install|clusterinit|clusterstart|clusterstop "
  echo "        singleinit|singlestart|singlestop "
}

case "$1" in
  install)
    install
  ;;
  clusterinit)
    clusterinit
  ;;
  clusterstart)
    clusterstart
  ;;
  clusterstop)
    clusterstop
  ;;
  singleinit)
    singleinit
  ;;
  singlestart)
    singlestart
  ;;
  singlestop)
    singlestop
  ;;
  *)
    others
  ;;
esac
