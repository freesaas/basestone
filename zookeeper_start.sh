#!/bin/sh

PID=`ps -ef | grep zookeeper | grep java | awk '{print $2}'`

if [ -n "$PID" ]; then
  kill -9 $PID
  echo "Kill pid:"$PID
else
  echo "No available zookeeper to kill!"
fi

. zookeeper/bin/zkServer.sh start
