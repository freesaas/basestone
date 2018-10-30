#!/bin/sh

# 1.清理
REDIS_PID=`ps -e | grep redis-server | awk '{print $1}'`
if [ -n "$REDIS_PID" ]; then
  kill -9 $REDIS_PID
  echo "1.杀死Redis进程成功："$REDIS_PID
else
  echo "1.没有存在的Redis ^-^"
fi
