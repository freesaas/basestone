#!/bin/sh
TARGET_HOST=192.168.9.53
if [ ! -f zookeeper-3.4.12.tar.gz ]; then
  curl -O http://apache.fayea.com/zookeeper/zookeeper-3.4.12/zookeeper-3.4.12.tar.gz
  echo "Downloaded successfully!"
fi

for target in 192.168.9.52 192.168.9.53
do
  ssh newqur@${target} "mkdir -p /home/newqur/sof/zookeeper/"
  echo "yes" | scp create.sh newqur@${target}:/home/newqur/sof/zookeeper/
  echo "yes" | scp zookeeper-3.4.12.tar.gz newqur@${target}:/home/newqur/sof/zookeeper/
  ssh newqur@${target} "chmod u+x /home/newqur/sof/zookeeper/create.sh"
  #ssh newqur@192.168.9.52 "cd /home/newqur/sof/zookeeper"
  #ssh newqur@192.168.9.52 "./create.sh"
done
