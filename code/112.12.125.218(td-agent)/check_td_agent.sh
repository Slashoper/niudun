#! /bin/sh
grep -i 'error' /var/log/td-agent/td-agent.log > /dev/null
errorstatus=$?
tail -n6 /var/log/td-agent/td-agent.log | grep  -i 'recovered forwarding' > /dev/null
recoveredstatus=$?
tail -n6 /var/log/td-agent/td-agent.log | grep  -i 'retry succeeded' > /dev/null
succeededstatus=$?
tail -n6 /var/log/td-agent/td-agent.log | grep  -i 'ROOT' > /dev/null
startstatus=$?
if [ $errorstatus -eq 0 ] && [ $succeededstatus -eq 0 -o $recoveredstatus -eq 0 -o $startstatus -eq 0 ]
then
	echo 2
elif [ $errorstatus -eq 0 ] && [ $succeededstatus -ne 0  -a $recoveredstatus -ne 0 -a $startstatus -ne 0 ]
then
	echo 1
else		
	echo 2
fi
