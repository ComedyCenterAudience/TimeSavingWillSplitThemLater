#!/bin/bash

print_netinfo() {

IP=$(ip -4 addr | awk '/inet / && $2 !~ /^127/ {print $2}' | head -n1 | cut -d/ -f1)
PREFIX=$(ip -4 addr | awk '/inet / && $2 !~ /^127/ {print $2}' | head -n1 | cut -d/ -f2)

mask=$(( 4294967295 ^ ((1 << (32 - PREFIX)) - 1) ))
oct1=$(( (mask >> 24) & 255 ))
oct2=$(( (mask >> 16) & 255 ))
oct3=$(( (mask >> 8) & 255 ))
oct4=$(( mask & 255 ))
MASK="$oct1.$oct2.$oct3.$oct4"

GATEWAY=$(ip route | awk '/default/ {print $3}')

cat <<EOF
IP = $IP
MASK = $MASK
GATEWAY = $GATEWAY
EOF

}