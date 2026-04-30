#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Use $0 <directory>/"
    exit 1
fi

dir="$1"

if [ ! -d "$dir" ]; then
    echo "'$dir' is not a directory"
    exit 1
fi

if [[ ! "$dir" == */ ]]; then
    echo "Directory path must end with '/'"
    exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
    exec sudo "$0" "$@"
fi

source functions.sh

start_time=$(date +%s.%N)

total_folders=$(find "$dir" -type d | wc -l)

top5_folders_sizes=$(find "$dir" -mindepth 1 -type d -exec du -bs {} + | sort -nr | head -n 5)

total_files=$(find "$dir" -type f | wc -l)

conf_files=$(find "$dir" -type f -name "*.conf" | wc -l)
log_files=$(find "$dir" -type f -name "*.log" | wc -l)
sym_links=$(find "$dir" -type l | wc -l)

file_output=$(find "$dir" -type f -exec file {} +)
text_files=$(echo "$file_output" | grep -c -i ':\s.*text')
exec_files=$(echo "$file_output" | grep -c -i ':\s.*executable')
archive_files=$(echo "$file_output" | grep -c -i ':\s.*\(archive\|compressed\|zip\|gzip\|bzip2\|xz\|7-zip\|rar\|cpio\|ar\)')

top10_files_sizes=$(find "$dir" -type f -exec du -bs {} + | sort -nr | head -n 10)

exec_paths=$(echo "$file_output" | grep -i ':\s.*executable' | cut -d: -f1)
if [ -n "$exec_paths" ]; then
    top10_exec_sizes=$(echo "$exec_paths" | while read -r p; do du -bs "$p"; done | sort -nr | head -n 10)
else
    top10_exec_sizes=""
fi

end_time=$(date +%s.%N)
execution_time=$(echo "scale=1; $end_time - $start_time" | bc)

echo "Total number of folders (including all nested ones) = $total_folders"
echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
if [ -n "$top5_folders_sizes" ]; then
    i=1
    echo "$top5_folders_sizes" | while read -r size path; do
        hsize=$(human_size $size)
        echo "$i - $path/, $hsize"
        i=$((i+1))
    done
else
    echo "etc up to 5"
fi
echo "Total number of files = $total_files"
echo "Number of:"
echo "Configuration files (with the .conf extension) = $conf_files"
echo "Text files = $text_files"
echo "Executable files = $exec_files"
echo "Log files (with the extension .log) = $log_files"
echo "Archive files = $archive_files"
echo "Symbolic links = $sym_links"
echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
if [ -n "$top10_files_sizes" ]; then
    i=1
    echo "$top10_files_sizes" | while read -r size path; do
        hsize=$(human_size $size)
        type="${path##*.}"
        echo "$i - $path, $hsize, $type"
        i=$((i+1))
    done
else
    echo "etc up to 10"
fi
echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"
if [ -n "$top10_exec_sizes" ]; then
    i=1
    echo "$top10_exec_sizes" | while read -r size path; do
        hsize=$(human_size $size)
        hash=$(md5sum "$path" | awk '{print $1}')
        echo "$i - $path, $hsize, $hash"
        i=$((i+1))
    done
else
    echo "etc up to 10"
fi
echo "Script execution time (in seconds) = $execution_time"