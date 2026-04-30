#!/bin/bash

set -e

source ./generator.sh

OUTPUT_DIR="${1:-./logs}"
mkdir -p "$OUTPUT_DIR"

echo "5 nginx log files will be created in '$OUTPUT_DIR'."

read -p "Should the log files be for the same day or for consecutive days? (same/consecutive): " mode
[[ "$mode" =~ ^(same|consecutive)$ ]] || {
    echo "Invalid choice, enter 'same' or 'consecutive'." >&2
    exit 1
}

case "$mode" in
    same)
        generate_same_day_logs "$OUTPUT_DIR"
        ;;
    consecutive)
        generate_all_logs "$OUTPUT_DIR"
        ;;
    *)
        echo "Invalid choice. Please enter 'same' or 'consecutive'." >&2
        exit 1
        ;;
esac

echo ""
echo "Log files created"
ls -lh "$OUTPUT_DIR"/*.log