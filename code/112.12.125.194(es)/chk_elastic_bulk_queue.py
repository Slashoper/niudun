#!/usr/bin/env python
# -*- coding: utf-8 -*-
# author: wugq@fastweb.com.cn
# time  : 2016-05-10

import commands
import sys,os
import time


def get_elastic_bulk_queue() :
    try :
        #cmd = "/usr/bin/curl -XGET http://61.174.14.194:9200/_cat/thread_pool?v -s | /bin/awk '{if(NR>1)print $1,$3, $4}' | /bin/awk '{if($2>0 || $3>0)print $1,$2,$3}'"
        cmd = "/usr/bin/curl -XGET http://61.174.14.194:9200/_cat/thread_pool?v -s | /bin/awk '{if(NR>1)print $1,$3, $4}' | /bin/awk '{if($2==8 && $3>5)print $1,$2,$3}'"
        ret = commands.getoutput(cmd)
        wrt = open('/var/log/kibana_nginx.log', 'a')
        if len(ret) > 0 :
            stop_kibana_nginx()
            wrt.write('%s\t%s\n'%(time.strftime('%Y-%m-%d %H:%M:%S'), '============ Stop kibana Nginx ============'))
            wrt.write('%s\n'%(ret))
            print ret
        else:
            kiban_proc = "/bin/ps -ef | /bin/grep '/opt/kibana/bin/' | /bin/grep -v 'grep'"
            nginx_proc = "/bin/ps -ef | /bin/grep 'nginx' | /bin/grep -v 'grep'"
            kiban_ret  = commands.getoutput(kiban_proc) 
            nginx_ret  = commands.getoutput(nginx_proc) 
            if ( len(kiban_ret) > 0 and len(nginx_ret) > 0 ) :
                pass
            else:
                start_kibana_nginx()
                wrt.write('%s\t%s\n'%(time.strftime('%Y-%m-%d %H:%M:%S'), '============ Start kibana Nginx ==========='))
        wrt.close()
    except Exception, e:
        print e

def stop_kibana_nginx() :
    try :
        nginx_stop = "/usr/local/openresty/nginx/sbin/nginx -s stop"
        kiban_stop = "/etc/init.d/kibana stop"
        elast_stop = "/bin/bash /opt/bin/elastich_disable.sh"
        commands.getoutput(nginx_stop)
        time.sleep(1)
        commands.getoutput(kiban_stop)
        commands.getoutput(elast_stop)
    except Exception, e:
        print e

def start_kibana_nginx() :
    try :
        kiban_start = "/etc/init.d/kibana start"
        nginx_start = "/usr/local/openresty/nginx/sbin/nginx"
        elast_start = "/bin/bash /opt/bin/elastich_enable.sh"
        commands.getoutput(kiban_start)
        time.sleep(3)
        commands.getoutput(nginx_start)
        commands.getoutput(elast_start)
    except Exception, e:
        print e

if __name__ == "__main__" :
    get_elastic_bulk_queue()
