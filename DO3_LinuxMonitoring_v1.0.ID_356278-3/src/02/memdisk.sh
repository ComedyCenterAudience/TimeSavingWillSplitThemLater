#!/bin/bash

print_memdisk() {

RAM_TOTAL=$(free -b | awk '/Mem:/ {printf "%.3f GB", $2/1024/1024/1024}')
RAM_USED=$(free -b | awk '/Mem:/ {printf "%.3f GB", $3/1024/1024/1024}')
RAM_FREE=$(free -b | awk '/Mem:/ {printf "%.3f GB", $4/1024/1024/1024}')

SPACE_ROOT=$(df -BM / | awk 'NR==2 {printf "%.2f MB", $2}')
SPACE_ROOT_USED=$(df -BM / | awk 'NR==2 {printf "%.2f MB", $3}')
SPACE_ROOT_FREE=$(df -BM / | awk 'NR==2 {printf "%.2f MB", $4}')

cat <<EOF
RAM_TOTAL = $RAM_TOTAL
RAM_USED = $RAM_USED
RAM_FREE = $RAM_FREE
SPACE_ROOT = $SPACE_ROOT
SPACE_ROOT_USED = $SPACE_ROOT_USED
SPACE_ROOT_FREE = $SPACE_ROOT_FREE
EOF

}
