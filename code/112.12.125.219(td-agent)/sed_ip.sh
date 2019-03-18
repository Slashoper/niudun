#! /bin/sh
#Check ip
host=`ip a  | grep '\<inet\>' | grep -v 'inet 10\|inet 127\|inet 192' | grep -v '/32' | awk '{print $2}'  | awk -F '/' '{print $1}' | awk -F "." 'BEGIN {OFS="_"}{print $3,$4}'`
sed -i 's/server.name = "cdn.newdefend.com";/server.name = "'"$host"'.waf";/g' /usr/local/fastcache/etc/fastcache.conf
