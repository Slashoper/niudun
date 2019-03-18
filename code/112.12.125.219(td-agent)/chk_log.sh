#! /bin/sh
#UserParmaeter=check.confd.log,bash /etc/zabbix/chk_log.sh -F /var/log/confd.log -O /tmp/confd_old.log -q "error"
#PATH=""
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4

ECHO="/bin/echo"
GREP="/bin/egrep"
DIFF="/usr/bin/diff"
TAIL="/usr/bin/tail"
CAT="/bin/cat"
RM="/bin/rm"
CHMOD="/bin/chmod"
TOUCH="/bin/touch"

PROGNAME=`/bin/basename $0`
PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`
REVISION="1.4.15"

#. $PROGPATH/utils.sh

print_usage() {
    echo "Usage: $PROGNAME -F logfile -O oldlog -q query"
    echo "Usage: $PROGNAME --help"
    echo "Usage: $PROGNAME --version"
}

print_help() {
    echo ""
    print_usage
    echo ""
    echo "Log file pattern detector plugin for Nagios"
    echo ""
}

# Make sure the correct number of command line
# arguments have been supplied

if [ $# -lt 1 ]; then
    print_usage
    exit $STATE_UNKNOWN
fi

# Grab the command line arguments

#logfile=$1
#oldlog=$2
#query=$3
exitstatus=$STATE_WARNING #default
while test -n "$1"; do
    case "$1" in
        --help)
            print_help
            exit $STATE_OK
            ;;
        -h)
            print_help
            exit $STATE_OK
            ;;
        --filename)
            logfile=$2
            shift
            ;;
        -F)
            logfile=$2
            shift
            ;;
        --oldlog)
            oldlog=$2
            shift
            ;;
        -O)
            oldlog=$2
            shift
            ;;
        --query)
            query=$2
            shift
            ;;
        -q)
            query=$2
            shift
            ;;
        -x)
            exitstatus=$2
            shift
            ;;
        --exitstatus)
            exitstatus=$2
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            print_usage
            exit $STATE_UNKNOWN
            ;;
    esac
    shift
done

# If the source log file doesn't exist, exit

if [ ! -e $logfile ]; then
    $ECHO "Log check error: Log file $logfile does not exist!\n"
    exit $STATE_UNKNOWN
elif [ ! -r $logfile ] ; then
    $ECHO "Log check error: Log file $logfile is not readable!\n"
    exit $STATE_UNKNOWN
fi

# If the old log file doesn't exist, this must be the first time
# we're running this test, so copy the original log file over to
# the old diff file and exit

if [ ! -e $oldlog ]; then
    $CAT $logfile > $oldlog
    $ECHO "Log check data initialized...\n"
    exit $STATE_OK
fi

# The old log file exists, so compare it to the original log now

# The temporary file that the script should use while
# processing the log file.
if [ -x /bin/mktemp ]; then
    tempdiff=`/bin/mktemp /tmp/check_log.XXXXXXXXXX`
else
    tempdiff=`/bin/date '+%H%M%S'`
    tempdiff="/tmp/check_log.${tempdiff}"
    $TOUCH $tempdiff
    $CHMOD 600 $tempdiff
fi

$DIFF $logfile $oldlog | $GREP -v "^>" > $tempdiff

# Count the number of matching log entries we have
count=`$GREP -c "$query" $tempdiff`

# Get the last matching entry in the diff file
lastentry=`$GREP "$query" $tempdiff | $TAIL -1`

$RM -f $tempdiff
$CAT $logfile > $oldlog

if [ "$count" = "0" ]; then # no matches, exit with no error
    $ECHO "0"
    exitstatus=$STATE_OK
else # Print total matche count and the last entry we found
    $ECHO "$count"
    exitstatus=$STATE_CRITICAL
fi

exit $exitstatus
