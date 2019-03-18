#!/usr/python/env
# -*- coding: utf8 -*-
# create at : 2016-04-21
# author : gangqi.wu@fastweb.com.cn.


import sys
import re
import time
import subprocess
file_log='/var/log/td-agent/td-agenthadoop3.log'
pattern = re.compile(r'error_class')

def current_time():
    return int(time.time())

def read_dns_log():
    count_list = []
    now_time = current_time()
    cmd = ('tail', '-n 1000', file_log)
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    for line in p.stdout.readlines():
        if re.findall(pattern, line) :
            lines = line.split()
            time_log = time.mktime(time.strptime('%s %s'%(lines[0], lines[1]), '%Y-%m-%d %H:%M:%S'))
            if ((now_time - time_log) <= 30) :
                count_list.append('%s\t%s'%(now_time, line))
            else:
                 pass
        else:
            pass
    print len(count_list)

if __name__ == "__main__":
    read_dns_log()
