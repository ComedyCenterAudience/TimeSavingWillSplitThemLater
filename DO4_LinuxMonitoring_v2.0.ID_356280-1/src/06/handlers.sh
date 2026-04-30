#!/bin/bash

sort_by_response() {
    goaccess "$1" --sort-panel="STATUS_CODES,BY_DATA,ASC" --log-format=COMBINED -a -o 1.html
}

sort_by_unique_ip() {
    goaccess "$1" --sort-panel="HOSTS,BY_HITS,ASK" --log-format=COMBINED -a -o 2.html
}

sort_by_error_response() {
    awk '$9 ~ /^4[0-9][0-9]$/ || $9 ~ /^5[0-9][0-9]$/' "$1" | goaccess - --log-format=COMBINED -o 3.html
}

sort_by_unique_ip_in_error_responses() {
    awk '$9 ~ /^4[0-9][0-9]$/ || $9 ~ /^5[0-9][0-9]$/' "$1" | \
        goaccess - \
        --log-format=COMBINED \
        --sort-panel="HOSTS,BY_HITS,ASK" \
        --enable-panel="HOSTS" \
        --ignore-panel="STATUS_CODES" \
        --ignore-panel="REFERRERS" \
        --ignore-panel="REFERRING_SITES" \
        --ignore-panel="KEYPHRASES" \
        --ignore-panel="VIRTUAL_HOSTS" \
        --ignore-panel="VISITORS" \
        --ignore-panel="BROWSERS" \
        --ignore-panel="OS" \
        --ignore-panel="VISIT_TIMES" \
        --ignore-panel="NOT_FOUND" \
        --ignore-panel="REQUESTS_STATIC" \
        --ignore-panel="REQUESTS" \
        --ignore-panel="TLS_TYPE" \
        --ignore-panel="MIME_TYPE" \
        --ignore-panel="GEO_LOCATION" \
        --ignore-panel="CACHE_STATUS" \
        --ignore-panel="REMOTE_USER" \
        -o 4.html
}