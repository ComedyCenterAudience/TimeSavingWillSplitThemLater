#!/bin/bash 

if [ $# -ne 3 ]; then
    echo "There are only $# parameters, instead of 3. Reminder:
    $0 <FolderChars> <FileChars.ExtChars> <SizeMb>
    
$0 az az.az 3Mb
Parameter 1 is a list of English alphabet letters used in folder names (no more than 7 characters). 
Parameter 2 the list of English alphabet letters used in the file name and extension (no more than 7 characters for the name, no more than 3 characters for the extension). 
Parameter 3 ? is the file size (in Megabytes, but not more than 100)."
    exit 1
fi

clock=$(date +%s)
clockHumanLike=$(date "+%Y-%m-%d %H:%M:%S")

source ./input.sh
source ./generator.sh
source ./logger.sh

checkInput "$@"
initLogger

echo "Start time: $clockHumanLike"
generateAll

endTime=$(date +%s)
endTimeHumanLike=$(date "+%Y-%m-%d %H:%M:%S")

echo "End time: $endTimeHumanLike"
echo "Elapsed time: $((endTime - clock)) seconds"

{
    echo ""
    echo "================================================================================"
    echo "Start time: $clockHumanLike"
    echo "End time: $endTimeHumanLike"
    echo "Elapsed time: $((endTime - clock)) seconds"
    echo "================================================================================"
    echo ""
} >> "$LogFile"