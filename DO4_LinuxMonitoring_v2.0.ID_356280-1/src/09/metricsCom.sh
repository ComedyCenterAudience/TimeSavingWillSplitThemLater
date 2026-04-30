#!/bin/bash

get_cpu() {
    local cpu user nice system idle iowait irq softirq steal
    local total1 idle1 total2 idle2 diff_total diff_idle
    read cpu user nice system idle iowait irq softirq steal < /proc/stat
    total1=$((user + nice + system + idle + iowait + irq + softirq + steal))
    idle1=$idle
    sleep 1
    read cpu user nice system idle iowait irq softirq steal < /proc/stat
    total2=$((user + nice + system + idle + iowait + irq + softirq + steal))
    idle2=$idle
    diff_total=$((total2 - total1))
    diff_idle=$((idle2 - idle1))
    echo $((100 * (diff_total - diff_idle) / diff_total))
}

get_ram_used() {
    local total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    local avail=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    local used=$((total - avail))
    echo $((used * 1024))
}

get_ram_free() {
    local avail=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    echo $((avail * 1024))
}

get_disk_used() {
    df --output=used / | tail -1 | awk '{print $1 * 1024}'
}

get_disk_free() {
    df --output=avail / | tail -1 | awk '{print $1 * 1024}'
}