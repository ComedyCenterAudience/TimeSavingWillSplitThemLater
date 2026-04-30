#!/bin/bash

if [ $# -ne 1 ]; then
    echo "$0 <1|2|3|4>
Depending on the value of the parameter, output the following:

    All entries sorted by response code;
    All unique IPs found in the entries;
    All requests with errors (response code ? 4xx or 5xxx);
    All unique IPs found among the erroneous requests."
    exit 1
fi

if [[ ! "$1" =~ ^[1-4]$ ]]; then
    echo "must be 1, 2, 3, or 4."
    exit 1
fi

LOG_DIR="${LOG_DIR:-../04/logs}"
if [ ! -d "$LOG_DIR" ]; then
    LOG_DIR="./logs" 
fi

if [ ! -d "$LOG_DIR" ]; then
    echo "'$LOG_DIR' not found."
    echo "logs in ./logs/"
    exit 1
fi

shopt -s nullglob
log_files=("$LOG_DIR"/*.log)
if [ ${#log_files[@]} -eq 0 ]; then
    echo "No .log files found in '$LOG_DIR'."
    exit 1
fi

source ./parser.sh

case $1 in
    1) entries_by_code ;;
    2) unique_ips ;;
    3) error_requests ;;
    4) error_unique_ips ;;
esac