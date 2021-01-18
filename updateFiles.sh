#!/bin/bash
# Description:	Updates files in destination directory from a src directory, only if modified.
# Parameters:	1: Source dir path
#				2: Destination dir path
# ver 1.3	shemadolev@gmail.com

if [ $# -ne 2 ]; then
	echo "Expecting 2 arguments as follows: $0 <srcDir> <destDir>"
else
	src="$1"
	dest="$2"
	
	if [ ! -d "$src" ]; then
		echo "Could not find directory '$src'."
		exit 1
	fi
	if [ ! -d "$dest" ]; then
		echo "Could not find directory '$dest'."
		exit 1
	fi

	for File in "$src"/*
	do
		File=`basename "$File"`
		if [[ -d "$src/$File" ]]; then #if this is a directory
			if [[ ! -d "$dest/$File" ]]; then #check if exists in dest
				#No matching folder - copy it all
				echo "New[dir]:	$dest/$File"
				cp -r "$src/$File" "$dest"
			else
				#recursively recall the script for this folder
				#echo "[Recursive call: $0 $src/$File $dest/$File]"
				"$0" "$src/$File" "$dest/$File"
			fi
		elif [[ -f "$src/$File" ]]; then #if this is a file
			# modified=`stat -c %y "$src/$File"`
			modified=$(date -r "$src/$File" $'+%d/%m/%Y %H:%M:%S');
			if [[ -f "$dest/$File" ]]; then #check if exists in dest
			# if [ "$src/$File" -nt "$dest/$File" ]; then #check if exists in dest
				if ! cmp -s "$src/$File" "$dest/$File"; then #if files are different
				#Check if src is newer from the dest
					if [ "$src/$File" -nt "$dest/$File" ]; then
						echo "Updated: $dest/$File $modified"
					else
						echo "Restored: $dest/$File $modified"
					fi
					cp "$src/$File" "$dest"
				fi
			else #file doesn't exist in dest
				echo "New: $dest/$File $modified"
				cp "$src/$File" "$dest"
			fi
		fi
	done
fi
