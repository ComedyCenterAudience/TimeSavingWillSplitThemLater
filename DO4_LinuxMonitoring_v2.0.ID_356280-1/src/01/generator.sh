#!/bin/bash

DateSuffix=$(date +%d%m%y)
MinFreeKb=1048576   # 1 GB

makeName() {
    local Allowed="$1"
    local MinLen=4
    local Len=${#Allowed}

    local Name="$Allowed"
    while [ ${#Name} -lt $MinLen ]; do
        local RandIndex=$(( RANDOM % Len ))
        Name+="${Allowed:RandIndex:1}"
    done

    # alphabetically
    echo "$Name" | grep -o . | sort | tr -d '\n'
}

haveEnoughSpace() {
    local Available=$(df -k / | awk 'NR==2 {print $4}')
    [ "$Available" -gt "$MinFreeKb" ]
}

generateAll() {
    for (( i=1; i<=NumFolders; i++ )); do
        haveEnoughSpace || break

        local FolderName="$(makeName "$FolderChars")_${DateSuffix}"
        local FolderPath="${AbsPath}/${FolderName}"
        mkdir -p "$FolderPath"
        logEntry "$FolderPath" "d" 0

        for (( j=1; j<=NumFiles; j++ )); do
            haveEnoughSpace || break 2

            local FileBase="$(makeName "$FileNameChars")_${DateSuffix}"
            local FileExt="$(makeName "$FileExtChars")"
            # Trim to max 3
            FileExt="${FileExt:0:3}"
            local FileName="${FileBase}.${FileExt}"
            local FilePath="${FolderPath}/${FileName}"

            dd if=/dev/zero of="$FilePath" bs=1024 count="$SizeKb" 2>/dev/null
            logEntry "$FilePath" "f" "$SizeKb"
        done
    done
}