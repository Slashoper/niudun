##**ElasticSearch 查询语法**
ElasticSearch是基于lucene的开源搜索引擎，它的查询语法关键字跟lucene一样，如下:
- 分页:from/size
- 字段:fields
- 排序:sort
- 查询:query
- 过滤:filter
- 高亮:highlight
- 统计:facet

Lucene支持基于词条的TermQuery、RangeQuery、PrefixQuery、BolleanQuery、PhraseQuery、WildcardQuery、FuzzyQuery

基本查询

POST _search

    {
    	"query": {
    		"query_string": {
    			"query": "test"
    		}
   		}
    }

多字段查询

	{
	    "query": {
	        "bool": {
	            "should": [
	                { "match": { "title": "Brown fox" }},
	                { "match": { "body":  "Brown fox" }}
	            ]
	        }
	    }
	}


通配符查询

    {
    	"query": {
    		"filtered" : {
    			"query" : {
    				"query_string" : {
    					"analyze_wildcard": true,
    					"query": "*118.192.170.34*"
    				}
    			}
    		}
   		}
    }

过滤结果

    {
    	"query": {
    		"query_string": {
    			"query": "test",
    			"fields": ["proxy_remote_user"]
    		}
    	},
    	"size":4, 
    	"from":0,
    	"_source": [ "proxy_remote_addr", "proxy_remote_user" ]
    }

精确查询

	{
	    "query": {
	        "constant_score": {
	            "filter": {
	                "term": {
	                    "proxy_remote_addr": "124.127.138.35"
	                }
	            }
	        }
	    }
	}

根据type过滤

	{
	  "query": {
	    "filtered": { 
	      "query": {
	        "query_string": { "query": "test" }
	      },
	      "filter": {	
	           "type": { "value": "42-51-132-94_proxy"}
		}
	    }
	  }
	}

排序

	{
	  "query": {
	    "filtered": { 
	      "query": {
	        "query_string": { "query": "test" }
	      }
	    }
	  },
	  "sort": { 
		"@timestamp": { "order": "desc" } 
	  }
	}

根据时间段查询

	{
	  "sort": {
	    "@timestamp": {
	      "order": "desc"
	    }
	  },
	  "query": {
	    "filtered": {
	      "query": {
	        "query_string": {
	          "query": "test"
	        }
	      },
	      "filter": {
	        "range": {
	          "@timestamp": {
	            "from": "2014-10-06T11:05:25+00:00",
	            "to": "2014-10-06T12:05:25+00:00"
	          }
	        }
	      }
	    }
	  }
	}
	
	{
	  "sort": {
	    "@timestamp": {
	      "order": "desc"
	    }
	  },
	  "query": {
	    "filtered": {
	      "query": {
	        "query_string": {
	          "query": "91kuaiche.com"
	        }
	      },
	      "filter": {
	        "range": {
	          "@timestamp": {
	            "from": "now-10h",
	            "to": "now"
	          }
	        }
	      }
	    }
	  }
	}
	
	{
	  "sort": {
	    "@timestamp": {
	      "order": "asc"
	    }
	  },
	  "query": {
	    "filtered": {
	      "query": {
	        "query_string": {
	          "query": "91kuaiche.com"
	        }
	      },
	      "filter": {
	        "range": {
	          "@timestamp": {
	            "from": "now-10h",
	            "to": "now"
	          }
	        }
	      }
	    }
	  }
	}

按时间查询

	{
		"query" : {
			"filtered" : {
				"filter" : { 
					"range" : { 
						"@timestamp" : { "gt" : "now-1h" }
						} 
					} 
				} 
			}, 
			"sort": {
				"@timestamp": {"order":"desc"}
			},
			"size":15,
			"from":0 
	}


聚合查询

	curl -XPOST http://10.26.201.205:9200/gamelog-9x-index/_search?search_type=count -d '
	{
	  "query": {
	      "match_all": { } },
	  "facets": {
	      "ChargeCount": {
	          "terms": {
	              "field": "money",
	              "all_terms" : true,
	              "order" : { "money" : "asc" },
	              "size": 100
	          }
	      }
	  }
	}'


	curl -XPOST "http://localhost:9200/gamelog-9x-index/_search?pretty=1" -d'
	{
	   "size": 0, 
	   "aggregations": {
	      "ChargeCount": {
	         "terms": {
	            "field": "money"
	         }
	      }
	   }
	}'



	curl -XPOST http://localhost:9200/gamelog-9x-index/_search?pretty  -d '
	{
	    "query" : {
	        "filtered" : {
	            "query" : { "match_all" : {}}
	        }
	    },
	    "aggs" : {
	        "intraday_return" : { "sum" : { "field" : "money" } }
	    }
	}'

and 查询

	curl ' http://localhost:9200/gamelog-9x-index/_search?pretty -XPOST -d '{
	  "query": {
	    "bool": {
	      "must": [
	        { "match": { "money":  { "query": "10"}}},
	        { "match": {  "gname":  { "query": "9s" }}}
	      ]
	    }
	  }
	}'

根据时间段查询

    curl http://localhost:9200/gamelog-9x-index/_search?pretty -XPOST -d '{
    "query": {
    	"bool": {
      		"must": [
    		{ "match": { "money":  {"query": "10"}}},
    		{ "match": { "dept":  {"query": "263"}}},
    		{"range" : {"@timestamp" : {
    			"gt" : "2015-03-12T11:44:16+08:00", 
    			"lt" : "2015-03-12T12:33:26+08:00" }}}
      		]
    		}
      		}
    	}
    }'


多index查询

    curl -XPOST http://audit.anquan.io:9200/_msearch?pretty=true -d '
    {"index":"waf-*","ignore_unavailable":true}
    {"size": 5,"query": {"filtered": { "query": {"query_string": { "analyze_wildcard": true,"query": "444"}}}}}
    '


如何获得查询语句，点击查询^箭头--->request---下拉就是查询语句
    curl -XGET http://61.174.14.194:9200/waf-2016.01.18/_search -d '{
    "size": 200,
    "sort": [
    {
      "@timestamp": {
        "order": "desc",
        "unmapped_type": "boolean"
      }
    }
    ],
    "query": {
    "filtered": {
      "query": {
        "query_string": {
          "query": "domain: *.kyospace.com",
          "analyze_wildcard": true
        }
      },
      "filter": {
        "bool": {
          "must": [
            {
              "range": {
                "@timestamp": {
                  "gte": 1453041561219,
                  "lte": 1453084761219,
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
    "highlight": {
    "pre_tags": [
      "@kibana-highlighted-field@"
    ],
    "post_tags": [
      "@/kibana-highlighted-field@"
    ],
    "fields": {
      "*": {}
    },
    "require_field_match": false,
    "fragment_size": 2147483647
    },
    "aggs": {
    "2": {
      "date_histogram": {
        "field": "@timestamp",
        "interval": "30m",
        "time_zone": "Asia/Shanghai",
        "min_doc_count": 0,
        "extended_bounds": {
          "min": 1453041561218,
          "max": 1453084761218
        }
      }
    }
    },
    "fields": [
    "*",
    "_source"
    ],
    "script_fields": {},
    "fielddata_fields": [
    "@timestamp"
    ]
    }' -s | python -m json.tool