#!/usr/bin/env python
# -*- coding:utf8
# auth: wugq@fastweb.com.cn
# at  : 2016-08-22
# change: 20160830 add total percentage of 5xx 

import time
import json
import os
import time
import httplib

query_domain = ["*bjpos.com"]

query_template = '''
curl -XGET http://61.174.14.194:9200/access-%s/fluentd/_search -d '
{
  "_source": {
    "include": ["domain", "status"],
    "exclude": ["host", "blockid", "request", "prov", "carrier", "city", "country", "referer", "referer_host", "p_response_time", "p_response_length", "ss", "latitude", "longitude", "size", "clientip", "agent", "fjx", "hackerid", "hit_status", "mc", "method", "p_server", "p_status", "protocol", "ruleid", "searchbot", "time", "xff", "long_lat_itude"]
  },
  "query": {
    "filtered": {
      "query": {
        "wildcard": {
          "domain": "%s"
        }
      },
      "filter": {
        "bool": {
          "must": [
            {
              "range": {
                "@timestamp": {
                  "gte": %d,
                  "lte": %d,
                  "format": "epoch_millis"
                }
              }
            }
          ],
	  "should": [
	    {
	       "term": {"status": 500}
	    },
	    {  "term": {"status": 502}
	    },
	    {  "term": {"status": 503}
	    },
	    {
	       "term": {"status": 504}
	    }
	  ],
          "must_not": [
            
          ]
        }
      }
    }
  },
  "size": 0,
  "aggs": {
    "2": {
      "terms": {
        "field": "status",
        "size": 6,
        "order": {
          "_count": "desc"
        }
      }
    }
  }
} ' -s
'''

query_template_domain_cont = '''
curl -XGET http://61.174.14.194:9200/access-%s/fluentd/_search -d '
{
  "query": {
    "filtered": {
      "query": {
        "query_string": {
          "query": "%s",
          "analyze_wildcard": true
        }
      },
      "filter": {
        "bool": {
          "must": [
            {
              "range": {
                "@timestamp": {
                  "gte": %d,
                  "lte": %d,
                  "format": "epoch_millis"
                }
              }
            }
          ],
          "must_not": []
        }
      }
    }
  },
  "size": 0,
  "aggs": {}
} ' -s 
'''


def Query_Time_Section() :
    '''查询区间5分钟的文档，当前时间是结束时间，减去300秒后推5分钟'''
    current_time_epoch = int(time.time())*1000
    start_time_epoch = current_time_epoch -300*1000
    return (start_time_epoch, current_time_epoch)


def Query_Template(times) :
    '''获得域名，开始，结束时间生成查询url获取数据'''
    start_time, end_time = times
    domain_result_dict = {}
    index_day = time.strftime("%Y.%m.%d")
    for domain in query_domain :
        '''查询域名500,502,503,504计数'''
        query_url = query_template % (index_day, domain, start_time, end_time)
        #print query_url
        process = os.popen(query_url)
        preprocessed = json.loads(process.read())
        result = ((preprocessed.get('aggregations')).get('2')).get('buckets') 
        process.close()

        '''查询域名总访问计数'''
        query_url_count = query_template_domain_cont % (index_day, domain, start_time, end_time)
        process_count = os.popen(query_url_count)
        preprocessed_count = json.loads(process_count.read())
        result_count = preprocessed_count.get('hits').get('total')
        process_count.close()
        result.append(result_count) 

        domain_result_dict[domain] = result
        time.sleep(1)
    Query_Results(domain_result_dict)
        

def Query_Results(write_result) :
    '''结果写入文本, 如果5分钟内大于等200写入报警信息'''
    #print type(write_result), write_result
    result = open('/tmp/resut_send_qq.log', 'w')
    date = time.strftime("%Y-%m-%d %H:%M:%S")
    result.write("%s\n"%date)
    for domain, http_5xx_count in write_result.iteritems():
        #print domain, http_5xx_count
        if len(http_5xx_count) > 1 :
            domain_write_flag = True
            for i in http_5xx_count[0:-1] :
                doc_count = i.get('doc_count')
                num_count = float(http_5xx_count[-1])
                total_percentage_5xx = doc_count/num_count*100 
                if (doc_count >= 1) or (total_percentage_5xx >= 3):
                     if domain_write_flag :
                         result.write("==== %s\n"%domain)
                         domain_write_flag = False
                     result.write("%s    %s    %.2f%%\n"%(i.get('key'), doc_count, total_percentage_5xx))
    result.write("\n")
    result.flush()
    result.close()
#    Query_Results_Send_QQ()
#
#
#def Query_Results_Send_QQ() :
#    '''发送QQ消息'''
#    #return
##    fp_result = open('/tmp/resut_bjpos_qq.log', 'r')
#    fp_result = open('/tmp/resut_send_qq.log', 'r')
##    msg_backup = open('/var/log/bjpos_5xx.log', 'a+')
#    msg_backup = open('/var/log/elastich_5xx.log', 'a+')
#    qq_context = fp_result.read()
#    msg_backup.write(qq_context)
#    msg_backup.close()
#    if len(qq_context) == 20 :
#        return 
#    qq_message = "/openqq/send_group_message?uid=542609035&content=%s"
#    #qq_message = "/openqq/send_group_message?gnumber=542609035&content=%s"
#    h = httplib.HTTPConnection("61.174.9.83",6370)
#    qq_context = ((qq_context.replace('%', "%25")).replace(' ', '%20')).replace('\n', '%0d%0a')
#    try :
#        h.request("GET", qq_message % qq_context)
#        #result = h.getresponse()
#        #print result.read()
#        #print result.status
#    except Exception as e:
#        print e
#    fp_result.close() 
#    return h.getresponse().close()
#

if __name__ == "__main__" :
    Query_Template(Query_Time_Section()) 

