## Elasticsearch如何安全重启节点 ##

Elasticsearch集群，有时候可能需要修改配置，增加硬盘，扩展内存等操作，需要对节点进行维护升级。但是业务不能停，如果直接kill掉节点，可能导致数据丢失。而且集群会认为该节点挂掉了，就开始转移数据，当重启之后，它又会恢复数据，如果你当前的数据量已经很大了，这是很耗费机器和网络资源的。
本文转载官方提供的安全重启集群节点的方法：

#关闭集群共享
1）、关闭nginx，停止所有访问连接。保证集群无连接
 /usr/local/openresty/nginx/sbin/nginx -s stop
2）、关闭集群自动负载均衡
curl -XPUT http://61.174.14.194:9200/_cluster/settings -d'
{
    "transient" : {
        "cluster.routing.allocation.enable" : "none"
    }
}'
3)、查看所有节点，然后关闭单个节点，或者所有节点
curl -XGET http://61.174.14.194:9200/_cat/nodes  #查看节点
curl -XPOST http://61.174.14.195:9200/_cluster/nodes/niudun_node195/_shutdown #关闭节点
4）、如果关闭过程中遇到无法关闭的节点，登录次服务器手动执行关闭命令
curl -XPOST http://61.174.14.195:9200/_cluster/nodes/niudun_node195/_shutdown
5）、修改内存大小，或者升级集群


第一步：先暂停集群的shard自动均衡。

	curl -XPUT http://192.168.1.2:9200/_cluster/settings -d'
	{
	    "transient" : {
	        "cluster.routing.allocation.enable" : "none"
	    }
	}'

curl -XPUT http://61.174.14.194:9200/_cluster/settings -d'
{
    "transient" : {
        "cluster.routing.allocation.enable" : "none"
    }
}'

curl -XPOST 'http://61.174.14.194:9200/_flush/synced' -s | python -m json.tool


第二步：shutdown你要升级的节点

	curl -XPOST http://192.168.1.3:9200/_cluster/nodes/nodename/_shutdown

	关闭所有 节点
	
	curl -XPOST 'http://localhost:9200/_shutdown'

第三步：升级重启该节点，并确认该节点重新加入到了集群中


第四步：重启启动集群的shard均衡

	curl -XPUT http://192.168.1.2/_cluster/settings -d'
	{
	    "transient" : {
	        "cluster.routing.allocation.enable" : "all"
	    }
	}'

curl -XPUT http://61.174.14.194:9200/_cluster/settings -d'
{
    "transient" : {
        "cluster.routing.allocation.enable" : "all"
    }
}'

到此整个集群安全升级并且重启结束。

第五步： 集群数据平衡
curl -XPUT http://61.174.14.194:9200/_cluster/settings -d'
{
    "transient" : {
        "cluster.routing.rebalance.enable" : "all"
    }
}' -s | python -m json.tool
