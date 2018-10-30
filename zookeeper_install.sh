#!/bin/sh

PWD=`pwd`
echo "Current dir:"$PWD

ZOOKEEPER_PID=`ps -ef | grep zookeeper | grep java | awk '{print $2}'`
if [ -n "$ZOOKEEPER_PID" ]; then
  kill -9 $ZOOKEEPER_PID
  echo "Kill zookeeper successfully: "$ZOOKEEPER_PID
else
  echo "There's no zookeeper exists ^-^"
fi

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
