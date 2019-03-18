

4）、使用索引模板
https://www.elastic.co/guide/en/elasticsearch/reference/2.1/indices-templates.html#indices-templates-exists

#创建索引模板
curl -XPUT localhost:9200/_template/template_1 -d '
{
    "template" : "te*",
    "settings" : {
        "number_of_shards" : 1
    },
    "mappings" : {
        "type1" : {
            "_source" : { "enabled" : false }
        }
    }
}
'

#删除索引模板
curl -XDELETE localhost:9200/_template/template_1


#查看索引模板
curl -XGET localhost:9200/_template/template_1                      #查看单个索引模板
curl -XGET localhost:9200/_template/temp*                           #正则匹配索引模板
curl -XGET localhost:9200/_template/template_1,template_2           #查看多个索引模板
curl -XGET localhost:9200/_template/                                #列出所有模板
curl -XHEAD -i localhost:9200/_template/template_1                  #判断template_1模板是否存在。存在200不存在404



5）、存储索引
方法一
#默认在config目录中，文件必须使用.mustache扩展结尾
config/scripts/

#为了执行存储模板，需要执行下面的查询语句
GET /_search
{
    "query": {
        "template": {
            "file": "my_template",           #文件名
            "params" : {
                "query_string" : "all about search"
            }
        }
    }
}

查询模板名称: config/scprit/my_template.mustache

方法二、
你可以注册一个特殊查询模板脚本:
PUT /_search/template/my_template
{
    "template": { "match": { "text": "{{query_string}}" }},
}

模板中引用它查询id参数
GET /_search
{
    "query": {
        "template": {
            "id": "my_template", 
            "params" : {
                "query_string" : "all about search"
            }
        }
    }
}

