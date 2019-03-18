#!/bin/bash
# author : wugq@fastweb.com.cn
# at time: 2015-11-12

find   /var/log/elasticsearch/ -type f -name "*log.`date +%Y-`*" -a ! -name "*.gz" -exec gzip "{}" \;
find   /var/log/elasticsearch/ -type f -mtime +20 -a -name "*.log.*-*-*.gz" -exec rm {} \;

#find  /home/elasticsearch/ -type f -name "*log.`date +%Y-`*" -a ! -name "*.gz" -exec gzip "{}" \;
#find  /home/elasticsearch/ -type f -mtime +20 -a -name "*.log.*-*-*.gz" -exec rm {} \;
