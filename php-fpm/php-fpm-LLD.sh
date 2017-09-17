#!/bin/bash
#!/bin/bash
##################################
# get list of available PHP-FPM socket on system
##################################
# Autor: Baji Zsolt <bajizs@cnt.rs>
##################################

#pid of php-fpm master process
FPM_MASTER_PID=`pgrep -f "php-fpm: master process"`

if [ -z "$FPM_MASTER_PID" ]; then
    exit 1;
fi

echo -n '{"data":['
SEPARATOR=$'\n\t'

IFS=$'\n'
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#find file sockets
for file in `sudo lsof -p $FPM_MASTER_PID | grep -e '/.\+ type=STREAM' | awk '{print $9}'`; do
    NAME=`$SCRIPTDIR/php-fpm-status.sh pool $file 2>/dev/null`
    if [ -n $NAME ]; then
        printf "%s" "$SEPARATOR"
        SEPARATOR=$',\n\t'
        printf  "%s%s%s" "{ \"{#SOCKET}\":\"" "$file" "\",\"{#POOL}\":\"" "$NAME" "\"}"
    fi
done

#find network sockets
for file in `sudo lsof -p $FPM_MASTER_PID -P | grep -e 'TCP .\+ \(LISTEN\)' | awk '{print $9}'`; do
    NAME=`$SCRIPTDIR/php-fpm-status.sh pool $file 2>/dev/null`
    if [ -n $NAME ]; then
        printf "%s" "$SEPARATOR"
        SEPARATOR=$',\n\t'
        printf  "%s%s%s" "{ \"{#SOCKET}\":\"" "$file" "\",\"{#POOL}\":\"" "$NAME" "\"}"
    fi
done

echo ""
echo ']}'

exit 0;

