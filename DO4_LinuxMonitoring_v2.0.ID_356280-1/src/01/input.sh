#!/bin/bash

AbsPath=""
NumFolders=0
FolderChars=""
NumFiles=0
FileNameChars=""
FileExtChars=""
SizeKb=0

checkInput() {
    AbsPath="$1"
    NumFolders="$2"
    FolderChars="$3"
    NumFiles="$4"
    local FileSpec="$5"
    local RawSize="$6"

    # 1) Path must exist, be a directory, and be absolute
    if [[ "$AbsPath" != /* ]]; then
        echo "1 must be absolute (start with '/')."
        exit 1
    fi
    if [ ! -d "$AbsPath" ]; then
        echo "'$AbsPath' is not a directory."
        exit 1
    fi

    # 2) Number of subfolders (positive integer)
    if ! [[ "$NumFolders" =~ ^[0-9]+$ ]] || [ "$NumFolders" -eq 0 ]; then
        echo "2 must be a positive integer."
        exit 1
    fi

    # 3) Folder letters: 1-7 English letters
    if ! [[ "$FolderChars" =~ ^[a-zA-Z]{1,7}$ ]]; then
        echo "3 must be 1-7 English letters."
        exit 1
    fi

    # 4) Number of files (positive integer)
    if ! [[ "$NumFiles" =~ ^[0-9]+$ ]] || [ "$NumFiles" -eq 0 ]; then
        echo "4 must be a positive integer."
        exit 1
    fi

    # 5) File spec: name.ext (1-7 letters for name, 1-3 for extension)
    if ! [[ "$FileSpec" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
        echo "5 must be like 'abc.def' (1-7 name letters, 1-3 extension letters)."
        exit 1
    fi

    FileNameChars="${FileSpec%.*}"
    FileExtChars="${FileSpec#*.}"

    # 6) Size in KB (1-100).
    if ! [[ "$RawSize" =~ ^[0-9]+kb$ ]]; then
        echo "6 format <numbers>kb (e.g., '3kb') with integer between 1 and 100."
        exit 1
    fi
    SizeKb=${RawSize%kb}
    if [ "$SizeKb" -lt 1 ] || [ "$SizeKb" -gt 100 ]; then
        echo "6 SizeKb must be an integer between 1 and 100."
        exit 1
    fi
}