#!/bin/bash

LogFile=""

initLogger() {
    LogFile="log_$(date +%Y%m%d_%H%M%S).log"
    echo "Logging to: $LogFile"
}

logEntry() {
    local Path="$1"
    local Type="$2"
    local SizeKb="$3"
    local TimeStamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$Path | $TimeStamp | $Type | ${SizeKb}KB" >> "$LogFile"
}