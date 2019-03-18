#! /bin/sh
source /etc/profile
ytime=`date -d "-1 day" +%Y%m%d`
gzip /cache/logs/${ytime}*.log
host=`ip a  | grep '\<inet\>' | grep -v 'inet 10\|inet 127\|inet 192' | grep -v '/32' | awk '{print $2}'  | awk -F '/' '{print $1}' | sed -n '1p'`
rsync -avC --progress /cache/logs/${ytime}*.log.gz --password-file=/etc/rsync.p fclog@61.174.9.66::fclog/$host/
status=$?
if [[ "$status" -eq 0 ]]
then
	echo $status 
	find /cache/logs/ -name "201*.log.gz" -mtime +1 -delete
fi
