#!/bin/bash
# Run diff on all files between 2 directories, recursively on all subfolders
# Parameters:
# 	1: First Directory
# 	2: Second directory
#	3: 0/1: Full diff results [default: 0]
# ver1.1 shemadolev@gmail.com

if [[ $# -lt 2 ]]; then
	echo "Please provide args: $0 <dir1> <dir2>"
	exit 1
fi

if [[ ! -d $1 ]]; then
	echo "Missing directory: $1"
	exit 1
fi
if [[ ! -d $2 ]]; then
	echo "Missing directory: $2"
	exit 1
fi

if [[ $# -lt 3 ]]; then
	fullRes=0 #default arg
else
	if [[ $3 -eq 1 ]] || [[ $3 -eq 0 ]]; then
		fullRes=$3
	else
		echo "Invlalid argument: 3rd argument should be 1 for showing diff results, or 0."
		exit 1
	fi
fi

for File in "$1"/*
do
	File=`basename "$File"`
	if [[ -d "$1/$File" ]]; then #if this is a directory - recall recursively
		# echo "recursive: $1/$File $2/$File"
		"$0" "$1/$File" "$2/$File" $fullRes
	elif [[ -f "$1/$File" ]]; then #if this is a file
		if [[ ! -f "$2/$File" ]]; then #check if not found in $2
			echo "Missing file: $2/$File"
		else
			# run diff on the files
			diffRes=$(diff "$1/$File" "$2/$File")
			if [[ -z $diffRes ]]; then #diff is empty == files are eqaul
				if (( $fullRes==1 )); then
					echo "Same: $1/$File == $2/$File"
				fi
			else
				echo "Different: $1/$File != $2/$File"
				if (( $fullRes==1 )); then
					echo "$diffRes"
				fi
			fi
		fi
	fi
done

exit 0
