#!/bin/bash

HOSTNAME_VAL=$(hostname)

TIMEZONE_VAL="$(cat /etc/timezone) UTC $(date +%z | sed 's/\(..\)\(..\)/\1:\2/')"

USER_VAL=$(whoami)

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_VAL="$PRETTY_NAME"
else
    OS_VAL="$(uname -s -r)"
fi

DATE_VAL=$(date "+%d %B %Y %H:%M:%S")

UPTIME_VAL=$(uptime -p | sed 's/^up //')

UPTIME_SEC_VAL=$(cat /proc/uptime | awk '{print int($1)}')

IP_VAL=$(ip -4 addr show | awk '/inet / && !/127.0.0.1/ {print $2}' | cut -d/ -f1 | head -n1)

DEFAULT_IFACE=$(ip -4 route show default | awk '{print $5}' | head -n1)
if [ -z "$DEFAULT_IFACE" ]; then
    DEFAULT_IFACE=$(ip -4 addr show | grep -v lo | grep -m1 inet | awk '{print $NF}')
fi
CIDR=$(ip -4 addr show dev "$DEFAULT_IFACE" | grep -w inet | awk '{print $2}' | cut -d/ -f2)

if [ -n "$CIDR" ]; then
    full=$((CIDR / 8))
    part=$((CIDR % 8))
    mask=""
    for i in 1 2 3 4; do
        if [ $i -le $full ]; then
            mask="${mask}255."
        elif [ $i -eq $((full+1)) ]; then
            n=$((256 - (1 << (8-part))))
            mask="${mask}${n}."
        else
            mask="${mask}0."
        fi
    done
    MASK_VAL="${mask%?}"
else
    MASK_VAL=""
fi

GATEWAY_VAL=$(ip route show default | awk '{print $3}')

RAM_TOTAL_VAL=$(free -k | awk '/^Mem:/ {printf "%.3f GB", $2/1024/1024}')
RAM_USED_VAL=$(free -k | awk '/^Mem:/ {printf "%.3f GB", $3/1024/1024}')
RAM_FREE_VAL=$(free -k | awk '/^Mem:/ {printf "%.3f GB", $4/1024/1024}')

SPACE_ROOT_VAL=$(df / | awk 'NR==2 {printf "%.2f MB", $2/1024}')
SPACE_ROOT_USED_VAL=$(df / | awk 'NR==2 {printf "%.2f MB", $3/1024}')
SPACE_ROOT_FREE_VAL=$(df / | awk 'NR==2 {printf "%.2f MB", $4/1024}')