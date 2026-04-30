#!/bin/bash

confirm() {
    read -p "Delete all found items? (y/N): " ans
    [[ "$ans" =~ ^[Yy]$ ]]
}

cleanByLog() {
    read -p "Path to log file: " log
    [ ! -f "$log" ] && { echo "Log not found."; exit 1; }

    echo "Reading $log..."
    tmp=$(mktemp)

    while IFS= read -r line; do
        [[ -z "$line" || "$line" =~ ^===== ]] && continue
        path=$(echo "$line" | cut -d'|' -f1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        [ -e "$path" ] && echo "$path" >> "$tmp"
    done < "$log"

    count=$(wc -l < "$tmp")
    [ "$count" -eq 0 ] && { echo "No existing items found."; rm -f "$tmp"; exit 0; }

    cat "$tmp"
    echo "Total: $count items."
    confirm && while read -r item; do rm -rf "$item" 2>/dev/null && echo "Deleted: $item"; done < "$tmp"
    rm -f "$tmp"
}

cleanByDate() {
    read -p "Exclude bin and sbin directories? (y/N): " ans
    local exclude=false
    [[ "$ans" =~ ^[Yy]$ ]] && exclude=true

    read -p "Enter search directories (space-separated, default: /): " input_dirs
    local dirs
    if [ -z "$input_dirs" ]; then
        dirs=("/")
    else
        read -ra dirs <<< "$input_dirs"
    fi

    read -p "Start (YYYY-MM-DD HH:MM): " start
    read -p "End   (YYYY-MM-DD HH:MM): " end

    # Validate dates
    date -d "$start" >/dev/null 2>&1 && date -d "$end" >/dev/null 2>&1 || {
        echo "Error: Invalid date format. Use YYYY-MM-DD HH:MM"
        exit 1
    }

    echo "searching dirs ${dirs[*]}"
    echo "range of time $start  ->  $end"
    echo "exclude bin/sbin for faster search $exclude"

    tmp=$(mktemp)

    for dir in "${dirs[@]}"; do
        if $exclude && [[ "$dir" =~ bin ]] || [[ "$dir" =~ sbin ]]; then
            echo "skipping $dir (cuz contains bin/sbin)"
            continue
        fi
        [ ! -d "$dir" ] && { echo "$dir does not exist"; continue; }

        # Pattern: *_DDMMYY
        find "$dir" -type f -name "*_[0-9][0-9][0-9][0-9][0-9][0-9]" -newermt "$start" ! -newermt "$end" 2>/dev/null >> "$tmp"
        find "$dir" -type d -name "*_[0-9][0-9][0-9][0-9][0-9][0-9]" -newermt "$start" ! -newermt "$end" 2>/dev/null >> "$tmp"
    done

    count=$(wc -l < "$tmp")
    [ "$count" -eq 0 ] && { echo "No matches."; rm -f "$tmp"; exit 0; }

    cat "$tmp"
    echo "Total $count items."
    confirm && while read -r item; do rm -rf "$item" 2>/dev/null && echo "deleted $item"; done < "$tmp"
    rm -f "$tmp"
}

cleanByMask() {
    read -p "Name mask (az_150426): " mask
    [ -z "$mask" ] && { echo "Mask empty."; exit 1; }

    read -p "dirs (space separated, default: /): " input_dirs
    local dirs
    if [ -z "$input_dirs" ]; then
        dirs=("/")
    else
        read -ra dirs <<< "$input_dirs"
    fi

    echo "search directories at ${dirs[*]}"
    echo "searching for '*$mask*'"

    tmp=$(mktemp)
    for dir in "${dirs[@]}"; do
        [ ! -d "$dir" ] && { echo "$dir does not exist, skipping."; continue; }
        find "$dir" -name "*${mask}*" 2>/dev/null >> "$tmp"
    done

    count=$(wc -l < "$tmp")
    [ "$count" -eq 0 ] && { echo "Nn matches."; rm -f "$tmp"; exit 0; }

    cat "$tmp"
    echo "Total: $count items."
    confirm && while read -r item; do rm -rf "$item" 2>/dev/null && echo "Deleted: $item"; done < "$tmp"
    rm -f "$tmp"
}