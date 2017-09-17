#!/bin/bash
##################################
# PHP-FPM status page to zabbix parser
#
#  - ping (return true or false of working status of the php-fpm pool)
#  - anything available via FPM status page
#
##################################
# Autor: Baji Zsolt <bajizs@cnt.rs>
##################################

# Zabbix requested parameter
ZBX_REQ_DATA="$1"
ZBX_REQ_DATA_URL="$2"

#cgi-fcgi executable location
CGI_FCGI_BIN=/usr/bin/cgi-fcgi

if [ -z "$ZBX_REQ_DATA_URL" ]; then
    >&2 echo "No connection parameters"
    exit 1
fi


command -v $CGI_FCGI_BIN >/dev/null 2>&1 || { echo >&2 "I require $CGI_FCGI_BIN but it's not installed.  Aborting."; exit 1; }

#check ping status (pool running)
if [ "$ZBX_REQ_DATA" == 'ping' ]; then 
    RESULT=$(SCRIPT_NAME=/ping SCRIPT_FILENAME=/ping REQUEST_METHOD=GET $CGI_FCGI_BIN -bind -connect $ZBX_REQ_DATA_URL | grep "pong")
    if [ -z "$RESULT" ]; then
        echo 0
    else
        echo 1
    fi
    exit 0
fi

STATUS=$(SCRIPT_NAME=/status SCRIPT_FILENAME=/status REQUEST_METHOD=GET $CGI_FCGI_BIN -bind -connect $ZBX_REQ_DATA_URL)

if [ -z "$STATUS" ]; then
    >&2 echo "Connection to socket unsucessfull, check URL: $ZBX_REQ_DATA_URL"
    exit 1
fi

RESULT=$(echo "$STATUS" | awk 'match($0, "^'"$ZBX_REQ_DATA"':[[:space:]]+(.*)", a) { print a[1] }')
if [ $? -ne 0 -o -z "$RESULT" ]; then
    >&2 echo "NOT SUPPORTED"
    exit 1
fi

echo $RESULT

exit 0