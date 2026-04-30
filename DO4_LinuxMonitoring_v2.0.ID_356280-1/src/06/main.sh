#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Enter only 1 param"
    echo "1 - All entries sorted by response code"
    echo "2 - All unique IPs found in the entries"
    echo "3 - All requests with errors (4xx or 5xx)"
    echo "4 - All unique IPs found among the erroneous requests"
    exit 1
elif [[ ! $1 =~ ^[1-4]$ ]]; then 
    echo "Enter 1 digit from 1 to 4"
    exit 1
fi

# Interactive GoAccess installation check
if ! command -v goaccess &> /dev/null; then
    echo "GoAccess is not installed."
    echo "Do you want to install it? (requires sudo)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes )
                echo "Installing GoAccess..."
                sudo apt update && sudo apt install -y goaccess
                if ! command -v goaccess &> /dev/null; then
                    echo "Installation failed. Exiting."
                    exit 1
                fi
                break
                ;;
            No )
                echo "Cannot proceed without GoAccess. Exiting."
                exit 1
                ;;
        esac
    done
fi

# Locate log files (same as your original)
LOG_DIR="${LOG_DIR:-../04/logs}"
if [ ! -d "$LOG_DIR" ]; then
    LOG_DIR="./logs"
fi

if [ ! -d "$LOG_DIR" ]; then
    echo "Log directory '$LOG_DIR' not found. Place logs in ../04/logs or ./logs"
    exit 1
fi

shopt -s nullglob
log_files=("$LOG_DIR"/*.log)
if [ ${#log_files[@]} -eq 0 ]; then
    echo "No .log files found in '$LOG_DIR'."
    exit 1
fi

# Combine logs into combined.log in the current directory
cat "${log_files[@]}" > combined.log
echo "Combined ${#log_files[@]} log file(s) into ./combined.log"

# Source the handlers
source ./handlers.sh

# Call the appropriate function
case $1 in
    1) sort_by_response "combined.log" ;;
    2) sort_by_unique_ip "combined.log" ;;
    3) sort_by_error_response "combined.log" ;;
    4) sort_by_unique_ip_in_error_responses "combined.log" ;;
esac