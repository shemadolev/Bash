#!/bin/bash
# Description:	Updates only existing files in destination directory from a src directory
# Parameters:	1: Source dir path
#				2: Destination dir path
# ver 1.1	shemadolev@campus.technion.ac.il

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

	notFound=""
	noUpdate=""
	Updated=""

	for File in "$dest"/*
	do
		File=`basename "$File"`
		#Check if file in dest exists in src
		if [[ -f "$src/$File" ]]; then 
			if cmp -s "$src/$File" "$dest/$File"; then
				noUpdate="$noUpdate $File"
			else
				Updated="$Updated $File"
				cp "$src/$File" "$dest"
			fi
		else
			notFound="$notFound $File"
		fi
	done
	if [[ ! -z "$Updated" ]]; then
		echo "# Updated:"
		echo "$Updated"
	fi
	if [[ ! -z "$noUpdate" ]]; then
		echo "# Already identical (no change):"
		echo "$noUpdate"
	fi
	if [[ ! -z "$notFound" ]]; then
		echo "# Weren't found in source:"
		echo "$notFound"
	fi
fi