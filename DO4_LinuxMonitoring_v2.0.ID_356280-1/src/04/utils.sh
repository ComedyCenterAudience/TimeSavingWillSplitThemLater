#!/bin/bash

# a random integer between min and max
rand_int() {
    local min=$1
    local max=$2
    echo $(( RANDOM % (max - min + 1) + min ))
}

# random element from an array
rand_element() {
    local arr=("$@")
    local idx=$(rand_int 0 $((${#arr[@]} - 1)))
    echo "${arr[idx]}"
}

#  random valid IPv4 address (192.168.1.1)
rand_ip() {
    printf "%d.%d.%d.%d" \
        $(rand_int 1 254) \
        $(rand_int 0 255) \
        $(rand_int 0 255) \
        $(rand_int 1 254)
}

# random date/time within (DD/MM/YYYY:HH:MM:SS +TZ)
#base date (2026-04-01)
rand_datetime() {
    local day=$1
    local hour=$(rand_int 0 23)
    local minute=$(rand_int 0 59)
    local second=$(rand_int 0 59)
    # nginx time format: 01/Apr/2026:13:55:36 +0000
    date -d "${day} ${hour}:${minute}:${second}" "+%d/%b/%Y:%H:%M:%S %z" 2>/dev/null || \
        date -d "${day} ${hour}:${minute}:${second}" "+%d/%b/%Y:%H:%M:%S +0000"
}

# Generate a random URL path
rand_url() {
    local paths=(
        "/index.html"
        "/images/logo.png"
        "/css/style.css"
        "/js/app.js"
        "/api/v1/users"
        "/api/v1/products"
        "/contact"
        "/about"
        "/downloads/file.zip"
        "/blog/post/42"
        "/search?q=test"
        "/login"
        "/logout"
        "/dashboard"
        "/profile"
    )
    rand_element "${paths[@]}"
}

# =============================================================================
# Response code meanings (in comments as required)
# =============================================================================
# 200 OK - Request succeeded
# 201 Created - Resource created successfully
# 400 Bad Request - Malformed request syntax
# 401 Unauthorized - Authentication required
# 403 Forbidden - Server refuses to authorize
# 404 Not Found - Resource not found
# 500 Internal Server Error - Generic server error
# 501 Not Implemented - Server does not support functionality
# 502 Bad Gateway - Invalid response from upstream server
# 503 Service Unavailable - Server temporarily overloaded/maintenance