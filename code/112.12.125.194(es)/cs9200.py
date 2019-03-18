#!/usr/bin/env python
import json
import commands

def get_code():
    try :
         #cmd='curl -t 10 -XGET http://61.174.14.195:9200/_cluster/health? -s'
         cmd='curl -t 10 -XGET http://61.174.14.194:9200/_cluster/health? -s'
         result = json.loads(commands.getoutput(cmd))
         if result['status'] == 'green' :
             print 0
         else:
             print 1
    except Exception, e:
         print 1

if __name__ == "__main__":
    get_code()
