#!/bin/bash

if [ "$#" -ne 0 ]; then
  echo "This script does not accept arguments"
  exit 1
fi

source ./sysinfo.sh
source ./netinfo.sh
source ./memdisk.sh

filename="$(date +"%d_%m_%y_%H_%M_%S").status"
output=$(print_sysinfo; print_netinfo; print_memdisk)
echo "$output"

echo
read -p "Save this information to a file? (Y/N): " answer

#the same date
# if [[ "$answer" == "Y" || "$answer" == "y" ]]; then
#   echo "$output" > "$filename"
#   echo "Saved to $filename"
# fi

#different date
if [[ "$answer" == "Y" || "$answer" == "y" ]]; then
  filename="$(date +"%d_%m_%y_%H_%M_%S").status"
  {
    print_sysinfo
    print_netinfo
    print_memdisk
  } > "$filename"
  echo "Saved to $filename"
fi
