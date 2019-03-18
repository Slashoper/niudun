一、Elasticsearch安装常见问题


1）、没有locked memory权限
[root@ctl-zj-122-226-111-082 config]# su - elasticsearch
-bash: ulimit: max locked memory: cannot modify limit: Operation not permitted

echo "ulimit -SHl unlimited" >> /etc/profile
echo "elasticsearch memlock soft memlock unlimited\nelasticsearch memlock hard memlock unlimited" >> /etc/security/limits.conf



2）、没有权限写文件
[elasticsearch@ctl-zj-122-226-111-082 bin]$ log4j:ERROR setFile(null,true) call failed.
java.io.FileNotFoundException: /cache/cache12/log/cefdfff5b2d39ba0859898c66767da63.log (Permission denied)

chown -R elasticsearch /cache/cache*


3)、凌晨到3点没有日志
索引设置不对，不能是[access-]YYYY.MM.DD
需要设置成access-*
20160105日志设置的索引，预计20160206索引才不会有冲突出现。因为有老数据。



4)、elasticsearch 2.0移除了_shutdown API，使用系统命令关闭启动
/home/elasticsearch/elasticsearch-2.1.1/bin/elasticsearch -d   #启动

关闭
kill `ps -ef |grep elasticsearch-2.1.1 |grep -v grep |awk '{print $2}'`


5)、映射问题
索引模板允许您定义的模板将自动应用到新创建的索引。
模板包括设置和映射,和一个简单的模式模板,控制如果将适用于索引创建模板。
https://www.elastic.co/guide/en/elasticsearch/reference/2.1/indices-templates.html


6）、