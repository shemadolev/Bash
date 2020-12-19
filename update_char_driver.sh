#!/bin/bash
# Description:	Execute this script in a folder with a MakeFile that compiles a Char Driver module.
#				Run the script to update the modole in the kernel. 
# Parameters: 	1. Name of the driver.
#				2. Full path of .o/.ko module to be installed.
#	  			3. Optional: Name of device file to be updated. If not provided, device files won't be updated
#				4. Optional: Minor number for the device file. If not provided, will be set to one available.
# Author:		shemadolev@campus.technion.ac.il v1.2 19/12/20

if [ $# -lt 2 ]; then
	echo "Missing arguments: <Driver name> <Full path of .o/.ko to install> <Optional: device file name> <Optional: minor number>"
	exit 1
fi

make > /dev/null
#Exit if make fails
if [ $? -ne "0" ]; then
	exit 1
fi

rmmod "$1" 2> /dev/null
insmod "$2"

#Check installed correctly
if [ $? -eq 1 ]; then
	echo "Make sure the driver name sent in the 1st argument is correct."
	exit 1
fi

#Get major number
major=`cat /proc/devices | grep "$1" | cut -d " " -f 1`

printf "'$1' driver updated successfuly. Major number: $major"

if [ $# -gt 2 ]; then
	#Update device file
	rm -f "/dev/$3"
	if [ $# -lt 4 ]; then
		#No minor provided, search for the max minor set and take the +1 of it.
		maxMinor=`ls -l /dev | awk '{if($5=="'$major',"){print}}' | awk '{print $6}' | sort | tail -n1`
		if [ maxMinor -eq 255 ]; then
			#No more space.
			printf ", failed finding available minor number for the new device.\n"
			exit 1
		fi
		(( minor=maxMinor+1 ))
	else
		minor=$4
	fi
	mknod "/dev/$3" c $major $minor
	if [ $? -eq 1 ]; then
		printf ", Failed making a new device.\n"
		exit 1
	fi
	printf ", device '$3' is updated with minor=$minor."
fi

printf "\n"

exit 0