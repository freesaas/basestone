#!/bin/sh

#3/4/5
VERSION=5
WORKSPACE=`pwd`
SINGLE_NODE=7000
INSTALL_IP=192.168.9.52
if [ $VERSION == 5 ]; then
  VERSION_NAME=redis-5.0.4
elif [ $VERSION == 3 ]; then
  VERSION_NAME=redis-3.2.3
fi

function install(){
  if [ ! -f "${VERSION_NAME}.tar.gz" ]; then
    REDIS_URL=http://download.redis.io/releases/${VERSION_NAME}.tar.gz
    wget -O ${VERSION_NAME}.tar.gz ${REDIS_URL}
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
    sed -i "s/bind 127.0.0.1/bind $INSTALL_IP/g" redis-$node.conf
    sed -i "s/6379/$node/g" redis-$node.conf
    sed -i "s/daemonize no/daemonize yes/g" redis-$node.conf
    sed -i "s/# cluster-enabled yes/cluster-enabled yes/g" redis-$node.conf
    sed -i "s/# cluster-config-file nodes-${node}.conf/cluster-config-file nodes-${node}.conf/g" redis-$node.conf
  done
}

function clusterstart(){
  command=""
  for node in {7001..7006}
  do
    redis-dist/bin/redis-server redis-$node.conf
    command=${command}" $INSTALL_IP:"${node}
  done
  sleep 5
  echo yes | redis-dist/bin/redis-cli --cluster create ${command} --cluster-replicas 1
}

function clusterstop(){
  for node in {7001..7006}
  do
    redis-dist/bin/redis-cli -h $INSTALL_IP -p $node shutdown
  done
}

function clusterclear(){
  clusterstop
  rm -rf dump.rdb
  for node in {7001..7006}
  do
    rm -rf redis-$node.conf nodes-$node.conf
  done
}

function singleinit(){
  rm -rf dump.rdb
  rm -rf redis-$SINGLE_NODE.conf
  cp ${VERSION_NAME}/redis.conf redis-$SINGLE_NODE.conf
  sed -i "s/bind 127.0.0.1/bind $INSTALL_IP/g" redis-$SINGLE_NODE.conf
  sed -i "s/6379/$SINGLE_NODE/g" redis-$SINGLE_NODE.conf
  sed -i "s/daemonize no/daemonize yes/g" redis-$SINGLE_NODE.conf
}

function singlestart(){
  redis-dist/bin/redis-server redis-$SINGLE_NODE.conf &
}

function singlestop(){
  redis-dist/bin/redis-cli -h $INSTALL_IP -p $SINGLE_NODE shutdown
}

function singleclear(){
  singlestop
  rm -rf dump.rdb
  rm -rf redis-$SINGLE_NODE.conf nodes-$SINGLE_NODE.conf
}

# 其他情况
function others(){
  echo " Usage: install|clusterinit|clusterstart|clusterstop|clusterclear "
  echo "        singleinit|singlestart|singlestop|singleclear "
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
  clusterclear)
    clusterclear
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
  singleclear)
    singleclear
  ;;
  *)
    others
  ;;
esac
