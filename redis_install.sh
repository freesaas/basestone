#!/bin/sh
#3/4/5
./stop.sh
VERSION=5

if [ $VERSION == 5 ]; then
  VERSION_NAME=redis-5.0.0
elif [ $VERSION == 3 ]; then
  VERSION_NAME=redis-3.2.3
fi

if [ ! -f "${VERSION_NAME}.tar.gz" ]; then
  REDIS_URL=http://download.redis.io/releases/${VERSION_NAME}.tar.gz
  curl -O ${REDIS_URL}
fi
rm -rf ${VERSION_NAME} redis-dist

tar -zxf ${VERSION_NAME}.tar.gz
cd ${VERSION_NAME}
#make PREFIX=/home/newqur/sof/redis/redis-dist MALLOC=libc install 
make PREFIX=/home/newqur/sof/redis/redis-dist install
