#!/bin/sh

echo "My name is:$0"

echo "My options are:$-"

echo "My arguments are:$*"

while [ $# -gt 0 ]
do
	arg=$1
	echo "Processing arg:$arg"

	shift
done
