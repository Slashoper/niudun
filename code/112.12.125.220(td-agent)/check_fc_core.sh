#!/bin/sh
result=`ls -la /cache/logs/core.* 2>/dev/null|wc -l`
if [[ $result -eq 0 ]]
then
	echo 0
else
	echo 1
fi
