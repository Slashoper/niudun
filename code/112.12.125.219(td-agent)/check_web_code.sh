#! /bin/sh
status=`/usr/bin/curl -s --connect-timeout 20 --head -H Host:jk.anquan.io http://127.0.0.1/jk/index  | grep 'HTTP/1.1' | awk '{print $2}'`
if [[ $status -eq 200 ]] 
then
   echo $status
elif [[ "$status" == "" ]]
then 
  echo 0
elif [[  $status -eq 503 ]] 
then   
echo 200
else
  echo $status
fi
