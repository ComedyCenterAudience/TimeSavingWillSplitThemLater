#!/bin/bash

if [ $# -ne 4 ]; then
    echo "Need 4 numbers." >&2
    echo "Usage: $0 bg_name fg_name bg_value fg_value" >&2
    echo "Colors: 1 white, 2 red, 3 green, 4 blue, 5 purple, 6 black" >&2
    exit 1
fi

for param in "$@"; do
    if ! [[ "$param" =~ ^[1-6]$ ]]; then
        echo "Numbers 1 to 6 only." >&2
        exit 1
    fi
done

if [ "$1" -eq "$2" ]; then
    echo "Name colors must differ." >&2
    exit 1
fi

if [ "$3" -eq "$4" ]; then
    echo "Value colors must differ." >&2
    exit 1
fi

bg_name=$1
fg_name=$2
bg_value=$3
fg_value=$4

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/color.sh"
source "$SCRIPT_DIR/info.sh"
source "$SCRIPT_DIR/output.sh"