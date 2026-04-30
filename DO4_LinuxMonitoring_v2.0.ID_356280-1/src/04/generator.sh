#!/bin/bash

source ./utils.sh


HTTP_METHODS=(GET POST PUT PATCH DELETE)
HTTP_CODES=(200 201 400 401 403 404 500 501 502 503)
USER_AGENTS=(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Safari/605.1.15"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0"
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36"
    "Opera/9.80 (Windows NT 6.1; WOW64) Presto/2.12.388 Version/12.18"
    "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Edg/91.0.864.59"
    "Googlebot/2.1 (+http://www.google.com/bot.html)"
    "curl/7.68.0"
)


generate_entry() {
    local timestamp="$1"
    local ip=$(rand_ip)
    local method=$(rand_element "${HTTP_METHODS[@]}")
    local url=$(rand_url)
    local code=$(rand_element "${HTTP_CODES[@]}")
    local bytes=$(( RANDOM % 10000 + 100 ))
    local referer="-"
    if [ $((RANDOM % 3)) -eq 0 ]; then
        referer="http://example.com/previous-page"
    fi
    local agent=$(rand_element "${USER_AGENTS[@]}")

    
    
    echo "$ip - - [$timestamp] \"$method $url HTTP/1.1\" $code $bytes \"$referer\" \"$agent\""
}


generate_day_log() {
    local date_str="$1"        
    local output_file="$2"
    local num_entries=$(rand_int 100 1000)

    
    declare -a timestamps
    declare -a entries

    
    for ((i=0; i<num_entries; i++)); do
        local ts=$(rand_datetime "$date_str")
        timestamps+=("$ts")
        entries+=("$(generate_entry "$ts")")
    done

    
    
    for ((i=0; i<num_entries; i++)); do
        echo "${timestamps[$i]}|${entries[$i]}"
    done | sort -t'|' -k1,1 | cut -d'|' -f2- > "$output_file"
}


generate_all_logs() {
    local out_dir="$1"
    local today=$(date +%Y-%m-%d)

    
    for i in {1..5}; do
        local day=$(date -d "$today - $((5-i)) days" +%Y-%m-%d 2>/dev/null || \
                    date -v-$((5-i))d +%Y-%m-%d)  
        local file_name="${out_dir}/nginx_${day}.log"
        echo "Generating $file_name ($(rand_int 100 1000) entries)..."
        generate_day_log "$day" "$file_name"
    done
}

generate_same_day_logs() {
    local out_dir="$1"
    local single_day=$(date +%Y-%m-%d) 

    for i in {1..5}; do
        local file_name="${out_dir}/nginx_${single_day}_part${i}.log"
        echo "Generating $file_name ($(rand_int 100 1000) entries)..."
        generate_day_log "$single_day" "$file_name"
    done
}