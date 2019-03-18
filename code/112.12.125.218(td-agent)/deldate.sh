#!/bin/bash
# delete stale logs
# Wrote by Owen 2012/04/25
# last modified: 2014/12/10
# 脚本通用于边缘或父层的nginx/fastcache/squid相关日志处理

# 1. 会gzip自动压缩3小时之前的小时日志: 例如: 2014121122_(access|header|error).log
# 2. 空间使用大于70%会触发/cache/logs/下日志小时文件清理.
# 3. 清理7天之前各目录所有日志

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

DAY_AGO=`date -d '-7 days' '+%Y%m%d'`

DIRS=(
/cache/logs/customer/
/cache/logs/fastlog/
/cache/logs/err_log/
/cache/logs/acc_log/
/cache/logs/fcache_data/
/cache/logs/data/
/cache/logs/
)
for dir in ${DIRS[*]}; do
        if [ -d "$dir" ]; then
                echo == $dir ====================
                cd $dir || continue
		for log in `ls |egrep '^201[0-9]{5,9}(_|$)'`; do
			if [ ${log:0:8} -lt $DAY_AGO ]; then
				rm -rvf $log
			fi
		done
        fi
done
#----------------------------------------------------------------------
# 当空间>70%时，清理/cache/logs下旧日志
function used_percent(){
        local used=`df -h /cache/logs/|awk '$5~/[0-9]%/{sub(/%/,"",$5);print $5; exit}'`
        echo "$used" |grep -P '^[0-9]+$'
        [ $? -ne 0 ] && echo "Get used percent of /cache/logs failed!" && exit 1
}
MAX_PERCENT=70
USED_PERCENT=`used_percent`
if [ $USED_PERCENT -gt $MAX_PERCENT ]; then
        echo "space_used[$USED_PERCENT%] > max[$MAX_PERCENT%], start to delete..."
	cd /cache/logs/ 2>/dev/null &&
        ls [0-9]*.log | egrep '^[0-9]{10}_' |while read del_log; do
		rm -rvf $del_log
                [ `used_percent` -gt $MAX_PERCENT ] && continue || break
        done
else
        echo "space_used[$USED_PERCENT%] < max[$MAX_PERCENT%], skip clean."
fi

#----------------------------------------------------------------------
# 压缩3小时前的小时log文件
DATA_DIR=$(date -d "3 hour ago" +%Y%m%d)
ZIP_HOUR=$(date -d "3 hour ago" +%Y%m%d%H)
cd /cache/logs/ || exit 1
ls [0-9]*.log 2>/dev/null |egrep '^[0-9]{10}' |sort -nr |while read log; do 
	if [ ${log:0:10} -lt $ZIP_HOUR ]; then
		echo "Start gzip $log ..."
		nice -n 15 gzip $log
	fi
done

#----------------------------------------------------------------------
# for fastlog 
cd /cache/logs/fastlog/ 2>/dev/null || exit
HOUR_AGO=`date -d '-48 hour' '+%Y%m%d%H%M'`
for logfile in `ls |grep '^[0-9]\{12\}'`; do
        if [ $logfile -lt $HOUR_AGO ]; then
                echo "delete /cache/logs/fastlog/$logfile"
                rm -rvf $logfile
        fi
done

#----------------------------------------------------------------------
#DIRS=(
#/cache/cache0/
#/cache/cache1/
#/cache/cache2/
#/cache/cache3/
#/cache/logs/
#)
## for fastcache access logs
#HOUR_AGO=`date -d '-240 hour' '+%Y%m%d%H'`
#for dir in ${DIRS[*]}; do
#	cd $dir || continue
#	for logfile in `ls |grep '^[0-9]\{10\}_access.log'`; do
#	        log_date=${logfile%_*}
#	        if [ $log_date -lt $HOUR_AGO ]; then
#	                echo "delete /cache/logs/$logfile"
#	                rm -vf $logfile
#	        fi
#	done
#done
## for fastcache header logs
#HOUR_AGO=`date -d '-240 hour' '+%Y%m%d%H'`
#for dir in ${DIRS[*]}; do
#	cd $dir || continue
#	for logfile in `ls |grep '^[0-9]\{10\}_header.log'`; do
#	        log_date=${logfile%_*}
#	        if [ $log_date -lt $HOUR_AGO ]; then
#	                echo "delete /cache/logs/$logfile"
#	                rm -vf $logfile
#	        fi
#	done
#done
#
## for fastcache error logs
#HOUR_AGO=`date -d '-240 hour' '+%Y%m%d%H'`
#for dir in ${DIRS[*]}; do
#	cd $dir || continue
#	for logfile in `ls |grep '^[0-9]\{10\}_error.log'`; do
#	        log_date=${logfile%_*}
#	        if [ $log_date -lt $HOUR_AGO ]; then
#	                echo "delete /cache/logs/$logfile"
#	                rm -vf $logfile
#	        fi
#	done
#done
