#!/bin/csh -f

set usage = "Usage : $0 [ adp|nrtinput|nrtscw|nrtrev|nrtqla|consinput|consscw|consrev|conssa|consssa|conscor ] [ isdcsf1|2|3|4|5 ]"

if ( $#argv != 2 ) then
	echo $usage
	echo
	exit
endif

switch ( $1 )
	case isdcsf1:
	case isdcsf2:
	case isdcsf3:
	case isdcsf4:
	case isdcsf5:
		breaksw

	default:
		echo "$1 not a valid test system"
		echo $usage
		echo
		exit
endsw

switch ( $2 )
	case adp:
	case nrtinput:
	case nrtscw:
	case nrtrev:
	case nrtqla:
	case consinput:
	case consscw:
	case consrev:
	case conssa:
	case consssa:
	case conscor:
		rsh $1 integration.unittest.csh $2
		tcsh	#	this serves no other purpose than to hold the window open if the ssh exits
		breaksw

	default:
		echo "$2 not a valid pipeline"
		echo $usage
		echo
		exit
endsw






