#!/bin/csh -f

set usage = "Usage : $0 [ isdcsf1|2|3|4|5 isdclin1|2|3|4|5|6|7|8|9 ] [ adp|nrtinput|nrtscw|nrtrev|nrtqla|consinput|consscw|consrev|conssa|consssa|conscor|pipeline_lib|planckl1|planckdr|planckaux|iqla_scripts ]"

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
	case isdclin1:
	case isdclin2:
	case isdclin3:
	case isdclin4:
	case isdclin5:
	case isdclin6:
	case isdclin7:
	case isdclin8:
	case isdclin9:
	case isdclin10:
	case isdclin11:
	case isdclin12:
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
	case pipeline_lib:
	case planckl1:
	case planckdr:
	case planckaux:
	case iqla_scripts:
		set title = `echo $2 | tr "[:lower:]" "[:upper:]"`
		dtterm -title "$1-$title" -bs -bg white -fn '-misc-fixed-medium-r-*-*-12-*-*-*-*-*-iso8859-1' \
			-geometry 205x60 -l -lf $ISDC_OPUS/$2.log -ic -e integration.ssh.csh $1 $2
		breaksw

	default:
		echo "$2 not a valid pipeline"
		echo $usage
		echo
		exit
endsw

#	last line
