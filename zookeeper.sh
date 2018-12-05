#!/bin/sh

# Comments to support chkconfig on Linux
# chkconfig: 2345 64 36
 
# Author : deng.gonghai
# Date   : 2016-08-29
 
# ======================================
# Script for the xxx Server
# ======================================
 
# 服务名,该参数配合 ps -ef 命令用来查找服务信息.
# 设置此值的目的是查找服务进程ID时方便.一般来说此值具有一定的标识意义.
SERVER_NAME="MyTest"
 
# JDK安装目录,使用默认的JDK,推荐修改为JDK路径.
JAVA_HOME=$JAVA_HOME
 
# 使用的库文件目录,所有的外部jar包请放到这个目录下.
INFLIB=""
 
# 一般情况下该值为项目二进制文件的根目录.如果项目打成了jar包,则该值指定为jar包即可.
CLASS_PATH=test1.jar
 
# 虚拟机参数,设置虚拟机内存等一些配置.
#VM_ARGUMENTS="-Xms128m -Xmx256m -XX:MaxPermSize=64m \
#              -Djava.awt.headless=true \
#              -XX:+HeapDumpOnOutOfMemoryError \
#              -XX:+HeapDumpOnCtrlBreak \
#              -XX:HeapDumpPath=/app/logs\
#              -Xverbosegc:file=/app/logs/gc.log \
#              -Dfile.encoding=GBK \
#              -Duser.language=zh \
#              -Duser.region=CN \
#              -Dlog4j.configuration=file:./classes/log4j_cfg/log4j_MGR.properties "
 
# 服务启动的主类.
MainClass=com.ztesoft.mputils.StartTest
 
# main方法的参数在这里设置.参数与参数之间请用空格隔开.
# 字符串中间有空格,所以需要使用双引号.
PROGRAM_ARGUMENTS="args1 args2 args3"
 
# 自定义控制台输出路径,默认情况下为nohup.out
CONSOLE_LOG="nohup.out"

function install(){
  stop

  PWD=`pwd`
  echo "Current dir:"$PWD
  rm -rf zookeeper-3.4.12 zookeeper
  tar -zxf zookeeper-3.4.12.tar.gz

  echo "Unzip successfully!"
  mv zookeeper-3.4.12 zookeeper
  mkdir zookeeper/data
  mkdir zookeeper/logs

  #REAL_DATA_DIR="${PWD}/zookeeper/data"
  #REAL_DATA_DIR_SED=$(echo ${REAL_DATA_DIR} | sed -e 's/\//\\\//g')
  #echo $REAL_DATA_DIR_SED
  cp zookeeper/conf/zoo_sample.cfg zookeeper/conf/zoo.cfg
  sed -i 's/dataDir=\/tmp\/zookeeper/dataDir=\/home\/newqur\/sof\/zookeeper\/zookeeper\/data/g' zookeeper/conf/zoo.cfg
  sed -i '$a dataLogDir=\/home\/newqur\/sof\/zookeeper\/zookeeper\/logs/' zookeeper/conf/zoo.cfg
  sed -i '$a server.0=192.168.9.51:2888:3888' zookeeper/conf/zoo.cfg
  sed -i '$a server.0=192.168.9.52:2888:3888' zookeeper/conf/zoo.cfg
  sed -i '$a server.0=192.168.9.53:2888:3888' zookeeper/conf/zoo.cfg
  echo "Created successfully!"

  if [ -z "$1" ]; then
    echo "Usage: ./create.sh num"
    exit 1
  fi
  echo $1 > /home/newqur/sof/zookeeper/zookeeper/data/myid

  if [ `grep -c "ZOOKEEPER_HOME" /home/newqur/.bashrc` -eq '0' ]; then
    sed -i '$a export ZOOKEEPER_HOME=/home/newqur/sof/zookeeper/zookeeper' /home/newqur/.bashrc
    sed -i '$a PATH=$ZOOKEEPER_HOME/bin:$PATH' /home/newqur/.bashrc
  fi
}

# 启动服务(判断服务是否启动,只有没有启动的情况下,才启动.)
function start(){
  stop
  . zookeeper/bin/zkServer.sh start
}

# 停止服务
function stop(){
  PID=`ps -ef | grep zookeeper | grep java | awk '{print $2}'`

  if [ -n "$PID" ]; then
    kill -9 $PID
    echo "Kill process successfully:"$PID
  else
    echo "No available process to kill!"
  fi
}
# 重启
function restart(){
  start
}
# 其他情况
function others(){
  echo " Usage: start|stop|restart "
}
 
case "$1" in
  start)
    start
  ;;
  stop)
    stop
  ;;
  restart)
    restart
  ;;
  *)
    others
  ;;
esac
