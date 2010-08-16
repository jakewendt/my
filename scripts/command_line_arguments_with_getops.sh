#!/bin/sh

echo "My name is:$0"

echo "My options are:$-"

echo "My arguments are:$*"

#	What? No double-dashes?

#	getopts OPTSTRING VARIABLE_NAME
#	OPTSTRING is application dependent as is built on the expected options
#		'v' is valid
#		'f' is valid and is followed by a value
#	so the command ...
#		$0 -f qwer
#	is valid
#
#	ENVIRONMENT VARIABLES
#		OPTARG 
#	    stores the value of the option argument found by getopts.
#		OPTIND 
#	    contains the index of the next argument to be processed.
#	
while getopts vf: opt
do
	echo "Processing opt:$opt:with value:$OPTARG"
	case "$opt" in
		v)  vflag=on;;
		f)  filename="$OPTARG";;
		\?)		# unknown flag
			echo >&2 \
			"usage: $0 [-v] [-f filename] [file ...]"
			exit 1;;
	esac
done
shift `expr $OPTIND - 1`

