#!/bin/sh
PWD=`pwd`
BIN_DIR=${PWD}/redis-dist/bin
${BIN_DIR}/redis-server ${BIN_DIR}/redis.conf &
