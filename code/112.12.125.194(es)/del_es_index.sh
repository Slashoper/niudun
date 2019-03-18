#!/bin/bash
# auth: wugq@fastweb.com.cn
# at time: 2016-06-06

export PATH=/usr/local/bin:/usr/local/bin:/usr/local/rvm/gems/ruby-2.1.4/bin:/usr/local/rvm/gems/ruby-2.1.4@global/bin:/usr/local/rvm/rubies/ruby-2.1.4/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/rvm/bin:/usr/local/jdk1.8.0_65/bin:/root/bin:/root/bin:/usr/local/node/bin/

#for i in `curl http://61.174.14.194:9200/_cat/indices? -s |awk '{if($6==0)print $0}'|awk '{print $3}'`; do echo $i;curl -XDELETE http://61.174.14.194:9200/$i -s |python -m json.tool; done

echo "============================== `date +%Y%m%d_%H:%M:%S` ========================================"  >> /var/log/elasticsearch_crond.log
echo "time: `date +%Y%m%d_%H:%M:%S`   delete index start"  >> /var/log/elasticsearch_crond.log

## delete 32 day ago access-* index
delete_index_name="access-$(date -d "32 day ago" "+%Y.%m.%d")"
curl -XDELETE http://61.174.14.194:9200/$delete_index_name -s |python -m json.tool


## delete 90 day ago waf-* index
delete_index_waf="waf-$(date -d "90 day ago" "+%Y.%m.%d")"
curl -XDELETE http://61.174.14.194:9200/$delete_index_waf -s |python -m json.tool


## delete 180 day ago secure-* index
delete_index_secure="secure-$(date -d "180 day ago" "+%Y.%m.%d")"
curl -XDELETE http://61.174.14.194:9200/$delete_index_secure -s |python -m json.tool


## delete 7 day ago .marvel-es-* index
delete_index_marvel=".marvel-es-$(date -d "7 day ago" "+%Y.%m.%d")"
curl -XDELETE http://61.174.14.194:9200/$delete_index_marvel -s |python -m json.tool


## delete 7 day ago kern-* index
delete_index_kerner="kern-$(date -d "7 day ago" "+%Y.%m.%d")"
curl -XDELETE http://61.174.14.194:9200/$delete_index_kerner -s |python -m json.tool


## delete 7 day ago pwaf-* index
delete_index_pwaf="pwaf-$(date -d "7 day ago" "+%Y.%m.%d")"
curl -XDELETE http://61.174.14.194:9200/$delete_index_pwaf -s |python -m json.tool

echo "time: `date +%Y%m%d_%H:%M:%S`   delete index stop"  >> /var/log/elasticsearch_crond.log
echo "time: `date +%Y%m%d_%H:%M:%S`   change index rack from hot to stale start"  >> /var/log/elasticsearch_crond.log


## change index rack from hot to stale, hot data save 2 day
change_index_rack_2day=$(date -d "2 day ago" "+%Y.%m.%d")

curl -XPUT http://61.174.14.194:9200/access-$change_index_rack_2day/_settings -d '{ "index.routing.allocation.include.rack": "stale" }' -s | python -m json.tool
curl -XPUT http://61.174.14.194:9200/waf-$change_index_rack_2day/_settings -d '{ "index.routing.allocation.include.rack": "stale" }' -s | python -m json.tool
curl -XPUT http://61.174.14.194:9200/secure-$change_index_rack_2day/_settings -d '{ "index.routing.allocation.include.rack": "stale" }' -s | python -m json.tool
curl -XPUT http://61.174.14.194:9200/.marvel-es-$change_index_rack_2day/_settings -d '{ "index.routing.allocation.include.rack": "stale" }' -s | python -m json.tool
curl -XPUT http://61.174.14.194:9200/kern-$change_index_rack_2day/_settings -d '{ "index.routing.allocation.include.rack": "stale" }' -s | python -m json.tool
curl -XPUT http://61.174.14.194:9200/pwaf-$change_index_rack_2day/_settings -d '{ "index.routing.allocation.include.rack": "stale" }' -s | python -m json.tool
curl -XPUT http://61.174.14.194:9200/audit-$change_index_rack_2day/_settings -d '{ "index.routing.allocation.include.rack": "stale" }' -s | python -m json.tool
curl -XPUT http://61.174.14.194:9200/mod-$change_index_rack_2day/_settings -d '{ "index.routing.allocation.include.rack": "stale" }' -s | python -m json.tool


echo "time: `date +%Y%m%d_%H:%M:%S`   change index rack from hot to stale stop"  >> /var/log/elasticsearch_crond.log
echo "time: `date +%Y%m%d_%H:%M:%S`   optimize yearstady start"  >> /var/log/elasticsearch_crond.log

#### optimize yearstday index ###
optimize_index_name="access-$(date -d "1 day ago" "+%Y.%m.%d")" 
optimize_index_name_mod="mod-$(date -d "1 day ago" "+%Y.%m.%d")" 
optimize_index_waf="waf-$(date -d "1 day ago" "+%Y.%m.%d")" 
optimize_index_secure="secure-$(date -d "1 day ago" "+%Y.%m.%d")" 
optimize_index_kern="kern-$(date -d "1 day ago" "+%Y.%m.%d")" 
optimize_index_audit="audit-$(date -d "1 day ago" "+%Y.%m.%d")" 
optimize_index_marvel=".marvel-es-$(date -d "1 day ago" "+%Y.%m.%d")" 
optimize_index_pwaf="pwaf-$(date -d "1 day ago" "+%Y.%m.%d")" 

curl -XPOST http://61.174.14.194:9200/$optimize_index_name/_optimize?max_num_segments=1 -s | python -m json.tool >> /var/log/elasticsearch_crond.log
curl -XPOST http://61.174.14.194:9200/$optimize_index_name_mod/_optimize?max_num_segments=1 -s | python -m json.tool
curl -XPOST http://61.174.14.194:9200/$optimize_index_waf/_optimize?max_num_segments=1 -s | python -m json.tool
curl -XPOST http://61.174.14.194:9200/$optimize_index_secure/_optimize?max_num_segments=1 -s | python -m json.tool
curl -XPOST http://61.174.14.194:9200/$optimize_index_kern/_optimize?max_num_segments=1 -s | python -m json.tool
curl -XPOST http://61.174.14.194:9200/$optimize_index_audit/_optimize?max_num_segments=1 -s | python -m json.tool
curl -XPOST http://61.174.14.194:9200/$optimize_index_marvel/_optimize?max_num_segments=1 -s | python -m json.tool
curl -XPOST http://61.174.14.194:9200/$optimize_index_pwaf/_optimize?max_num_segments=1 -s | python -m json.tool

echo "time: `date +%Y%m%d_%H:%M:%S`   optimize yearstady stop"  >> /var/log/elasticsearch_crond.log
sleep 900
echo "time: `date +%Y%m%d_%H:%M:%S`   optimize 2 day ago index start"  >> /var/log/elasticsearch_crond.log

curl -XPOST http://61.174.14.194:9200/access-$change_index_rack_2day/_optimize?max_num_segments=1 -s | python -m json.tool >> /var/log/elasticsearch_crond.log
curl -XPOST http://61.174.14.194:9200/waf-$change_index_rack_2day/_optimize?max_num_segments=1 -s | python -m json.tool
curl -XPOST http://61.174.14.194:9200/secure-$change_index_rack_2day/_optimize?max_num_segments=1 -s | python -m json.tool
curl -XPOST http://61.174.14.194:9200/.marvel-es-$change_index_rack_2day/_optimize?max_num_segments=1 -s | python -m json.tool
curl -XPOST http://61.174.14.194:9200/kern-$change_index_rack_2day/_optimize?max_num_segments=1 -s | python -m json.tool
curl -XPOST http://61.174.14.194:9200/pwaf-$change_index_rack_2day/_optimize?max_num_segments=1 -s | python -m json.tool
curl -XPOST http://61.174.14.194:9200/audit-$change_index_rack_2day/_optimize?max_num_segments=1 -s | python -m json.tool
curl -XPOST http://61.174.14.194:9200/mod-$change_index_rack_2day/_optimize?max_num_segments=1 -s | python -m json.tool

echo "time: `date +%Y%m%d_%H:%M:%S`   optimize 2 day ago index stop"  >> /var/log/elasticsearch_crond.log
echo "time: `date +%Y%m%d_%H:%M:%S`   disable yearstday index start"  >> /var/log/elasticsearch_crond.log
# all disable index
#for i in `curl -XGET http://61.174.14.194:9200/_cat/indices -s | grep access | awk '{print $3}' | sort`
#    do
#      if [ "$i" != "$current_index_name" ]; then
#           echo $i
#           curl -XPUT http://61.174.14.194:9200/$i/_settings -d ' { "refresh_interval": "-1" } ' -s | python -m json.tool
#      fi
#    done
# yearstday disable


#### disable flush yearstday index
curl -XPUT http://61.174.14.194:9200/$optimize_index_name/_settings -d ' { "refresh_interval": "-1" } ' -s | python -m json.tool
curl -XPUT http://61.174.14.194:9200/$optimize_index_name_mod/_settings -d ' { "refresh_interval": "-1" } ' -s | python -m json.tool
curl -XPUT http://61.174.14.194:9200/$optimize_index_waf/_settings -d ' { "refresh_interval": "-1" } ' -s | python -m json.tool
curl -XPUT http://61.174.14.194:9200/$optimize_index_secure/_settings -d ' { "refresh_interval": "-1" } ' -s | python -m json.tool
curl -XPUT http://61.174.14.194:9200/$optimize_index_kern/_settings -d ' { "refresh_interval": "-1" } ' -s | python -m json.tool
curl -XPUT http://61.174.14.194:9200/$optimize_index_audit/_settings -d ' { "refresh_interval": "-1" } ' -s | python -m json.tool
curl -XPUT http://61.174.14.194:9200/$optimize_index_marvel/_settings -d ' { "refresh_interval": "-1" } ' -s | python -m json.tool

echo "time: `date +%Y%m%d_%H:%M:%S`   disable yearstday index stop"  >> /var/log/elasticsearch_crond.log
