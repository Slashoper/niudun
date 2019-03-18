#!/bin/bash
PATH=/usr/local/bin:/usr/local/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/jdk/bin:/root/bin:/root/bin


#su - elasticsearch -c "kill `ps -ef | grep Elasticsearch | grep -v grep | awk '{print $2}'`"

stop() {
         su - elasticsearch -c "kill `ps -ef | grep Elasticsearch | grep -v grep | awk '{print $2}'`"
         sleep 3
         echo `ps -ef | grep Elasticsearch | grep -v grep | wc -l`
}

start() {
         su - elasticsearch -c "/home/elasticsearch/elasticsearch-2.2.0/bin/elasticsearch -d"
         sleep 3
         echo `ps -ef | grep Elasticsearch | grep -v grep | wc -l`
}

# See how we were called.
case "$1" in
  start)
	start
	;;
  stop)
	stop
	;;
  *)
	echo $"Usage: $0 {start|stop}"
	exit 2
esac
