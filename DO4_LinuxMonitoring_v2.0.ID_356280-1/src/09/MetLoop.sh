#!/bin/bash

source /usr/local/bin/metricsCom.sh

METRICS_FILE="/var/www/html/prometheus/metrics"

while true; do
    CPU=$(get_cpu)
    RAM_USED=$(get_ram_used)
    RAM_FREE=$(get_ram_free)
    DISK_USED=$(get_disk_used)
    DISK_FREE=$(get_disk_free)

    cat > "$METRICS_FILE" << __METRICS__
# HELP cpu_usage_percent CPU usage percentage (user+system)
# TYPE cpu_usage_percent gauge
cpu_usage_percent $CPU
# HELP memory_used_bytes Used RAM in bytes
# TYPE memory_used_bytes gauge
memory_used_bytes $RAM_USED
# HELP memory_free_bytes Free RAM in bytes
# TYPE memory_free_bytes gauge
memory_free_bytes $RAM_FREE
# HELP disk_used_bytes Used disk space on / in bytes
# TYPE disk_used_bytes gauge
disk_used_bytes $DISK_USED
# HELP disk_free_bytes Free disk space on / in bytes
# TYPE disk_free_bytes gauge
disk_free_bytes $DISK_FREE
__METRICS__

    sleep 3
done