
for i in $(seq -f %02g 1 31) ;do curl -XDELETE "http://61.174.14.194:9200/access-2015.04.${i}" ;done

## ElasticSearch对运行大集群的几点优化建议 ##

0、系统优化
/etc/security/limits.conf:

elasticsearch - nofile 65535
elasticsearch - memlock unlimited

/etc/default/elasticsearch:

MAX_OPEN_FILES=65535
MAX_LOCKED_MEMORY=unlimited

1、内存优化
在bin/elasticsearch.in.sh中进行配置
修改配置项为尽量大的内存：

	ES_MIN_MEM=8g
	ES_MAX_MEM=8g

两者最好改成一样的，否则容易引发长时间GC（stop-the-world）

2.缩短recover_after_time超时配置，这样恢复可以马上进行，而不是还要再等一段时间

	gateway.recover_after_time: 5m

3.强制所有内存锁定,当jvm开始swapping时es的效率会降低

    bootstrap.mlockall: true

3.配置minimum_master_nodes，避免多个节点长期暂停时，有些节点的子集合试图自行组织集群，从而导致整个集群不稳定
4.调整系统允许用户打开文件数的最大值“max_file_descriptors” : 4096,字段表明当前系统的值。


out of memory错误

	index.cache.field.type: soft

设置es最大缓存数据条数和缓存失效时间

来把缓存field的最大值设置为50000

	index.cache.field.max_size: 50000

把过期时间设置成10分钟。

	index.cache.field.expire: 10m
	
强制使用IPV4
	
	JAVA_OPTS="$JAVA_OPTS -Djava.net.preferIPv4Stack=true"
	
# 分片数量，推荐分片数*副本数=集群数量
# 分片会带来额外的分割和合并的损耗，理论上分片数越少，搜索的效率越高
index.number_of_shards: 20
# 锁定内存，不让JVM写入swapping，避免降低ES的性能
bootstrap.mlockall: true
# 缓存类型设置为Soft Reference，只有当内存不够时才会进行回收
index.cache.field.max_size: 50000
index.cache.field.expire: 10m
index.cache.field.type: soft

https://www.loggly.com/blog/nine-tips-configuring-elasticsearch-for-high-performance/
https://www.elastic.co/guide/en/elasticsearch/guide/master/indexing-performance.html
https://blog.codecentric.de/en/2014/05/elasticsearch-indexing-performance-cheatsheet/
http://blog.sematext.com/2013/07/08/elasticsearch-refresh-interval-vs-indexing-performance/