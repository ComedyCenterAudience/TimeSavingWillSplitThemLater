#!/bin/bash

LogFile=""

initLogger() {
    LogFile="clogging_log_$(date +%Y%m%d_%H%M%S).log"
    echo "Logging to: $LogFile"
}

logEntry() {
    local Path="$1"
    local Type="$2"
    local Size="$3"
    local TimeStamp=$(date "+%Y-%m-%d %H:%M:%S")
    local Unit="MB"
    if [ "$Type" = "d" ]; then
        Unit="KB"
        Size="0"
    fi
    echo "$Path | $TimeStamp | $Type | ${Size}${Unit}" >> "$LogFile"
}