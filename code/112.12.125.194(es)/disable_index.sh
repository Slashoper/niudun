#!/bin/bash

shijian=`date  "+%Y.%m.%d"`
echo "current time:  $shijian"
PATH=/usr/local/bin:/usr/local/bin:/usr/local/rvm/gems/ruby-2.1.4/bin:/usr/local/rvm/gems/ruby-2.1.4@global/bin:/usr/local/rvm/rubies/ruby-2.1.4/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/rvm/bin:/usr/local/jdk/bin:/root/bin:/root/bin:/usr/local/node/bin

for i in `curl http://61.174.14.194:9200/_cat/indices?pretty -s | awk '{print $3}' | grep -v "$shijian" | sort `; do    echo $i;    curl -XPUT http://61.174.14.194:9200/$i/_settings -d ' { "refresh_interval": "-1" } ' -s | python -m json.tool; done
