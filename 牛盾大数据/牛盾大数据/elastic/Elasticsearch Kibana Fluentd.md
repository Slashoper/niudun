## Elasticsearch Kibana Fluentd ##
安装td-agent

	wget http://packages.treasuredata.com/2/redhat/6/x86_64/td-agent-2.2.0-0.x86_64.rpm

设置ruby源

	/opt/td-agent/embedded/bin/gem sources --remove https://rubygems.org/
	/opt/td-agent/embedded/bin/gem sources -a https://ruby.taobao.org/
	/opt/td-agent/embedded/bin/gem sources -l
	
安装elasticsearch插件

	/opt/td-agent/embedded/bin/gem install fluent-plugin-elasticsearch

安装kibana

	wget https://download.elastic.co/kibana/kibana/kibana-3.1.2.tar.gz

安装ES

	yum install java-1.7.0-openjdk
	wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.6.0.tar.gz

在线正则测试
	
	http://rubular.com/