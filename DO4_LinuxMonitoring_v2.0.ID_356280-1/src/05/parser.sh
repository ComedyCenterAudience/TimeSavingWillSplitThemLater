#!/bin/bash

entries_by_code() {
    awk '{ match($0, /"[^"]*" ([0-9]{3})/, a); print a[1] "|" $0 }' "${log_files[@]}" | sort -t'|' -k1,1n | cut -d'|' -f2-
}

unique_ips() {
    awk '{ print $1 }' "${log_files[@]}" | sort -u
}

error_requests() {
    awk '{ match($0, /"[^"]*" ([0-9]{3})/, a); if (a[1] ~ /^[45]/) print }' "${log_files[@]}"
}

error_unique_ips() {
    awk '{ match($0, /"[^"]*" ([0-9]{3})/, a); if (a[1] ~ /^[45]/) print $1 }' "${log_files[@]}" | sort -u
}