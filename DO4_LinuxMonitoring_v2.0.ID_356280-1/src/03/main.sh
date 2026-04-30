#!/bin/bash

if [ $# -ne 1 ]; then
    echo "one method argument is required"
    exit 1
fi

if [ $# -lt 1 ]; then
    echo "$0 <method> [method_args...]"
    echo "  1 - Delete using log file"
    echo "  2 - Delete by creation date/time range"
    echo "  3 - Delete by name mask"
    exit 1
fi

method="$1"
shift

if [[ ! "$method" =~ ^[123]$ ]]; then
    echo "Method must be 1, 2, or 3."
    exit 1
fi



source ./cleaner.sh

case $method in
    1) cleanByLog "$@" ;;
    2) cleanByDate "$@" ;;
    3) cleanByMask "$@" ;;
esac