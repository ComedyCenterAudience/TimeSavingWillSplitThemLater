#!/bin/bash

FolderChars=""
FileNameChars=""
FileExtChars=""
SizeMb=0

checkInput() {
    FolderChars="$1"
    local FileSpec="$2"
    local RawSize="$3"

    # 1) Folder letters: 1-7 English letters
    if ! [[ "$FolderChars" =~ ^[a-zA-Z]{1,7}$ ]]; then
        echo "FolderChars must be 1-7 English letters."
        exit 1
    fi

    # 2) File spec: name.ext (1-7 letters for name, 1-3 for extension)
    if ! [[ "$FileSpec" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
        echo "FileChars must be like 'abc.def' (1-7 name letters, 1-3 extension letters)."
        exit 1
    fi

    FileNameChars="${FileSpec%.*}"
    FileExtChars="${FileSpec#*.}"

    # 3) Size in MB (1-100).
    if ! [[ "$RawSize" =~ ^[0-9]+Mb$ ]]; then
    echo "Error: SizeMb must be in format <numbers>Mb (e.g., '3Mb') with integer between 1 and 100."
    exit 1
    fi
    SizeMb=${RawSize%Mb}
    if [ "$SizeMb" -lt 1 ] || [ "$SizeMb" -gt 100 ]; then
        echo "Error: SizeMb must be an integer between 1 and 100."
        exit 1
    fi
}