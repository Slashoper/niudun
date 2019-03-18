#!/bin/bash
export PATH=/usr/local/bin:/usr/local/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/jdk1.8.0_65/bin:/root/bin:/usr/local/jdk1.8.0_65/jre/lib/amd64/jli:/usr/local/kafka/bin:/usr/local/zookeeper/bin:/usr/local/jdk1.8.0_65/bin:/root/bin:/usr/local/jdk1.8.0_65/jre/lib/amd64/jli:/usr/local/kafka/bin:/usr/local/zookeeper/bin
source /etc/profile
/etc/init.d/td-agent stop
sleep 3
#sleep 30
/etc/init.d/td-agent restart
kill  `ps -ef |grep td-agent2 | grep -v grep |awk '{print $2}'`
kill  `ps -ef |grep td-agent2 | grep -v grep |awk '{print $2}'`
kill  `ps -ef |grep td-agent2 | grep -v grep |awk '{print $2}'`
sleep 3
#sleep 30
/opt/td-agent/embedded/bin/ruby /usr/sbin/td-agent2 --group td-agent --log /var/log/td-agent/td-agent2.log --use-v1-config --daemon /var/run/td-agent/td-agent2.pid
kill  `ps -ef |grep td-agent3 | grep -v grep |awk '{print $2}'`
kill  `ps -ef |grep td-agent3 | grep -v grep |awk '{print $2}'`
kill  `ps -ef |grep td-agent3 | grep -v grep |awk '{print $2}'`
sleep 3
#sleep 30
/opt/td-agent/embedded/bin/ruby /usr/sbin/td-agent3 --group td-agent --log /var/log/td-agent/td-agent3.log --use-v1-config --daemon /var/run/td-agent/td-agent3.pid

