#!/bin/bash
# Description:	Execute a program/script and print its runtime when it finishes.
# Parameters:	1: Command to execute in the shell
#			   [2: Precision digits. Default=4. ]
# ver 1.0	shemadolev@gmail.com

if (( $#==0 )); then
	echo "Usage: $0 <command> [<seconds digits precision]"
	exit 1
fi
#default digit precision
p=4
if (( $#>1 )); then
	if (( $2>=0 )); then
		p=$2
	fi
fi

START=$(date +%s.%N)
$1
END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
# printf "%.*f\n" $p $x     <= Round x to p digits precision: 
DIFF_RND=$(printf "%.*f\n" $p $DIFF)
echo "Total runtime: $DIFF_RND seconds."