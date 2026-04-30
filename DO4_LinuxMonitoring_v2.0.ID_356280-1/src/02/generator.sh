#!/bin/bash

DateSuffix=$(date +%d%m%y)
MinFreeKb=1048576   # 1 GB
MaxSubfolders=100


makeName() {
    local Letters="$1"
    local Name="$Letters"
    local Len=${#Letters}

    # >= 5
    while [ ${#Name} -lt 5 ]; do
        local RandIndex=$(( RANDOM % Len ))
        Name+="${Letters:RandIndex:1}"
    done

    # Sort the characters so the order matches
    echo "$Name" | grep -o . | sort | tr -d '\n'
}

getRandomDir() {
    local Candidates=(
        "/tmp"
        "/var/tmp"
        "/home"
        "/mnt"
        "/media"
        "/srv"
    )

    # bin sbin
    local SafeDirs=()
    for Dir in "${Candidates[@]}"; do
        if [[ "$Dir" =~ bin ]] || [[ "$Dir" =~ sbin ]]; then
            continue
        fi
        if [ -d "$Dir" ] && [ -w "$Dir" ]; then
            SafeDirs+=("$Dir")
        fi
    done

    # if no safe dirs found
    if [ ${#SafeDirs[@]} -eq 0 ]; then
        echo "/tmp"
        return
    fi

    local RandIndex=$(( RANDOM % ${#SafeDirs[@]} ))
    echo "${SafeDirs[$RandIndex]}"
}

haveEnoughSpace() {
    local Available=$(df -k / | awk 'NR==2 {print $4}')
    [ "$Available" -gt "$MinFreeKb" ]
}

generateAll() {
    local NumFolders=$(( RANDOM % MaxSubfolders + 1 ))

    for (( i=1; i<=NumFolders; i++ )); do
        haveEnoughSpace || {
            echo "less than 1GB free on /."
            break
        }

        local BaseDir=$(getRandomDir)
        local FolderName="$(makeName "$FolderChars")_${DateSuffix}"
        local FolderPath="${BaseDir}/${FolderName}"

        mkdir -p "$FolderPath" 2>/dev/null || continue
        logEntry "$FolderPath" "d" 0

        # 1-50 for simplicity
        local NumFiles=$(( RANDOM % 50 + 1 ))

        for (( j=1; j<=NumFiles; j++ )); do
            haveEnoughSpace || break 2

            local FileBase="$(makeName "$FileNameChars")_${DateSuffix}"
            local FileExt="$(makeName "$FileExtChars")"
            FileExt="${FileExt:0:3}"   # =< 3 chars
            local FileName="${FileBase}.${FileExt}"
            local FilePath="${FolderPath}/${FileName}"

            # Create file
            dd if=/dev/zero of="$FilePath" bs=1M count="$SizeMb" 2>/dev/null
            [ -f "$FilePath" ] && logEntry "$FilePath" "f" "$SizeMb"
        done
    done
}