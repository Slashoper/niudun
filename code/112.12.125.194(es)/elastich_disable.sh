#!/bin/bash

curl -XPOST 'http://61.174.14.194:9200/_flush/synced' -s | python -m json.tool
sleep 3
/usr/bin/curl -XPUT http://61.174.14.194:9200/_cluster/settings -d'
{
    "transient" : {
        "cluster.routing.allocation.enable" : "none"
    }
}'


