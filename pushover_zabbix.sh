#!/bin/bash
set -x
# Set Location
ZADIR=/usr/lib/zabbix/alertscripts

# Get CMD Parameters
PUser=$1
PTitle=$2
PMessage=$3

# Parce Message Body
PPriority=2
PRetry=60
PExpire=3600

echo 'START' >> /tmp/pushover.log
echo "USER: $PUser" >> /tmp/pushover.log
echo "TITLE: $PTitle" >> /tmp/pushover.log

echo pushover.sh -U$PUser -t"$PTitle"  >> /tmp/pushover.log
$ZADIR/./pushover.sh -U$PUser -t"$PTitle" "$PMessage" &>> /tmp/pushover.log
echo '..........' >> /tmp/pushover.log

# -p$PPriority -r$PRetry -e$PExpire -U$PUser -t$PTitle $PMessage