#! /bin/sh
aide -C | grep 'Total number of files' -A 3  > /tmp/check_result.txt
add=`grep 'Added files:' /tmp/check_result.txt  | awk '{print $3}'`
remove=`grep 'Removed files:' /tmp/check_result.txt  | awk '{print $3}'`
change=`grep 'Changed files:' /tmp/check_result.txt  | awk '{print $3}'`
if [[ "$add" -eq 0 && "$remove" -eq 0 && "$change" -eq 0 ]]
then
        echo 1 
elif [[ "$add" -ne 0 ||  "$remove" -ne 0 || "$change" -ne 0 ]]
then
	echo "$add$remove$change"
else
        echo 1
fi
