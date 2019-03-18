Elasticsearch 2.0配置说明


elasticsearch.yml是elasticsearch主要的配置文件，所有的配置都在这个文件里完成，一般情况下，默认的配置已经可以比较好地运行一个集群了，但你也可以对其进行微调。

在环境变量中的参数可以用来作为配置参数的值，比如配置文件里举的一个例子为：

node.rack: ${RACK_ENV_VAR}，再比如${JAVA_HOME}等。

下面对其配置参数作一说明。

Ø  Cluster

1.cluster.name

集群名称，如果有多个集群，那么每个集群名就得是唯一的。

Ø  Node

1．node.data

集群中的节点名称，比如前面说的82、83、84三台机子每台都有一个名称，你也可以不设这个名称，默认的集群启动时会自己给每个节点初始化一个名称，但强烈建议这里还是由自己设置比较好。

2．node.master

该节点是否是master，true表示是的，false表示否，默认是true.

3．node.data

该节点是否存储数据，默认true表示是的。

对于上面两个节点，如果你希望该节点只是一个master，但不存储数据，则应当设置为：

node.master: true

node.data: false

如果你希望该节点只存储数据，但不是一个master，则应该设置：

node.master: false

node.data: true

如果你既不希望该节点为一个master，也不想它存储数据，则应该设置为：

node.master: false

node.data: false

这种情况一般是你希望该节点仅仅是作为一个搜索负载均衡器，比如从各节点得到数据，聚合结果等。

4．  node.rack

这是与该节点相关联的一个属性，用来标识某一节点，它的设置也是key:value的形式如node.rack: rack83，我对其进行设置后的输出如下：{rack=rack83, master=true}，目前没有发现它的作用在哪里，可以采用默认的不用设置。

5．node.max_local_storage_nodes

设置一台机子能运行的节点数目，一般采用默认的1即可，因为我们一般也只在一台机子上部署一个节点。

Ø  Index

1．  index.number_of_shards

设置一个索引被分成的分片数，默认是5

2．index.number_of_replicas

设置一个索引有几个拷贝，默认为1。拷贝指的是其它节点对该节点的拷贝，比如在84上创建了一个索引，那么这个拷贝会存在于82和83上，这是一个分布式的属性。

拷贝越多，则搜索性能越佳，而分片越多则索引创建性能越好。

Ø  Paths

1．path.conf

配置文件目录，默认为es根目录下的config目录。

2．path.data

索引存储路径，默认为es根目录下的data目录，可以有多个存储路径，各存储路径用逗号隔开，如：path.data: /path/to/data1,/path/to/data2

3．path.work

临时文件存放目录，默认为es根目录下的work目录

4．path.logs

日志文件存放目录，默认为es根目录下的logs目录。

5．path.plugins

插件的安装目录，默认为es根目录下的plugins目录。

Ø  Plugin

1．plugin.mandatory

这个属性的值为各个插件的名称，如果该值里所列的插件没安装，则该节点将不能启动，默认是没有插件。

Ø  Memory

1. bootstrap.mlockall

Es在内存不够JVM开启swapping的时候，表现得会很差，所以为了避免这个问题，将该属性设为true，表示锁定es所使用的内存。

Ø  Network And HTTP

1．network.bind_host

Es节点绑定的地址，为一个ip地址（IPv4或IPv6）

2．network.publish_host

Es发布的地址，其它节点通过这个地址与其进行通信

3．network.host

该节点网络地址，也是一个ip地址，如果设置了该属性，则network.bind_host与network.publish_host都不用再设置了，比如我这里三台机子设置的值分别为：

118.200.108.82、118.200.108.83、118.200.108.84。

4．transport.tcp.port

节点之间通信的端口，默认为9300，在我们应用程序中调用es的方法提交索引创建时也是使用的这个端口。

5．http.port

http访问端口，默认是9200，通过这个端口，调用方可以索引查询请求。

6．http.max_content_length

设置内容的最大容量，默认是100MB

7．http.enabled

是否禁止http访问，默认是false。

Ø  Gateway

Gateway是一种存储集群中各节点元数据（meta data）的状态方式，这里的元数据主要用来记录所有的索引在创建时各自的设置和明确的类型映射。每次当元数据改变，比如一个索引被加入或被删除，这些变化都会通过gateway存储起来。当集群启动时，这些状态将会从gateway中读取并应用。

gateway.type
gateway类型，默认是local，也是es官方强烈建议的。

gateway.recover_after_nodes
在多少个节点启动后，允许数据恢复进程启动，默认是1

gateway.recover_after_time
设置数据恢复进程初始化的超时时间，默认是5分钟

gateway.expected_nodes
设置在集群中的多少个节点启动后马上开始数据恢复进程（不用等到gateway.recover_after_time这个属性设置的时间到）

Ø  Recovery Throttling

这里的设置是用来控制分片分配的进程，当各节点间进行初始化恢复、索引拷贝分配、再次负载均衡，或再增加或去掉节点的时候。

cluster.routing.allocation.node_initial_primaries_recoveries
初始化数据恢复时，并发恢复线程的个数，默认为4。

cluster.routing.allocation.node_concurrent_recoveries
添加删除节点或负载均衡时并发恢复线程的个数，默认为4

indices.recovery.max_size_per_sec
设置数据恢复时限制的带宽，默认为0，表示无限制。

indices.recovery.concurrent_streams
这个参数来限制从其它分片恢复数据时最大同时打开并发流的个数，默认为5

Ø  Discovery

discovery.zen.minimum_master_nodes
设置这个参数来保证集群中的节点可以知道其它N个有master资格的节点。默认为1，对于大的集群来说，可以设置大一点的值（2-4）。

discovery.zen.ping.timeout
设置集群中自动发现其它节点时ping连接超时时间，默认为3秒，对于比较差的网络环境可以高点的值来防止自动发现时出错

discovery.zen.ping.multicast.enabled
设置是否打开多播来发现来发现节点，默认是true

discovery.zen.ping.unicast.hosts
设置集群中master节点的初始列表，可以通过这些节点来自动发现新加入集群的节点。


