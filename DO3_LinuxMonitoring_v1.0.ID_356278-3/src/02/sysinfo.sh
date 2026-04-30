#!/bin/bash

print_sysinfo() {

HOSTNAME=$(hostname)
TIMEZONE="$(cat /etc/timezone) UTC $(date +%:::z)"
USER=$(whoami)
OS=$(cat /etc/issue | awk '{print $1, $2}')
DATE=$(date +"%d %B %Y %T")
UPTIME=$(uptime -p)
UPTIME_SEC=$(awk '{print int($1)}' /proc/uptime)

cat <<EOF
HOSTNAME = $HOSTNAME
TIMEZONE = $TIMEZONE
USER = $USER
OS = $OS
DATE = $DATE
UPTIME = $UPTIME
UPTIME_SEC = $UPTIME_SEC
EOF
}