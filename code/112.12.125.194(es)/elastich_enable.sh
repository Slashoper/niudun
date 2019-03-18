#!/bin/bash

/usr/bin/curl -XPUT http://61.174.14.194:9200/_cluster/settings -d'
{
    "transient" : {
        "cluster.routing.allocation.enable" : "all"
    }
}'

###
#/usr/bin/curl -XPUT http://61.174.14.194:9200/_cluster/settings -d'
#{
#    "transient" : {
#        "cluster.routing.rebalance.enable" : "all"
#    }
#}'
