#!/bin/bash

human_size() {
    local bytes=$1
    local size
    local unit
    if [[ $bytes -ge 1073741824 ]]; then
        size=$(echo "scale=1; $bytes / 1073741824" | bc)
        unit="GB"
    elif [[ $bytes -ge 1048576 ]]; then
        size=$(echo "scale=1; $bytes / 1048576" | bc)
        unit="MB"
    elif [[ $bytes -ge 1024 ]]; then
        size=$(echo "scale=1; $bytes / 1024" | bc)
        unit="KB"
    else
        size=$bytes
        unit="B"
    fi
    size=${size%.0}
    echo "$size $unit"
}