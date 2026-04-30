#!/bin/bash


if [ $# -ne 6 ]; then
	echo "There are only $# parameters, instead of 6. Reminder:
	$0 <AbsPath> <NumFolders> <FolderChars> <NumFiles> <FileChars.ExtChars> <SizeKb>

$0 /opt/test 4 az 5 az.az 3kb
Parameter 1 is the absolute path.
Parameter 2 is the number of subfolders.
Parameter 3 is a list of English alphabet letters used in folder names (no more than 7 characters).
Parameter 4 is the number of files in each created folder.
Parameter 5 is the list of English alphabet letters used in the file name and extension (no more than 7 characters for the name, no more than 3 characters for the extension).
Parameter 6 is file size (in kilobytes, but not more than 100)."
	exit 1
fi

source ./input.sh
source ./generator.sh
source ./logger.sh

checkInput "$@"
initLogger
generateAll
