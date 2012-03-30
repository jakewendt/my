#!/bin/csh -f

set usage = "Usage : $0 [ adp|nrtinput|nrtscw|nrtrev|nrtqla|consinput|consscw|consrev|conssa|consssa|conscor|pipeline_lib|planckl1|iqla_scripts ]"

if ( $#argv != 1 ) then
	echo $usage
	echo
	exit
endif

switch ( $1 )
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
	case iqla_scripts:
		#env
		#ftools:          aliased to setenv LHEASOFT /isdc/sw/ftools/5.3.1/WS/7/lheasoft/SunOS_5.8_sun4u/; source $LHEASOFT/lhea-init.csh

		repeat 3 echo ""
		echo "Running $1 unit_test on $HOST"
		repeat 3 echo ""
		unsetenv ISDC_IC_TREE
		#	unsetenv DISPLAY
		#setenv LHEASOFT /isdc/sw/ftools/5.3.1/WS/7/lheasoft/SunOS_5.8_sun4u/
		source $LHEASOFT/lhea-init.csh
		cd ${ISDC_OPUS}/$1
		#	$ISDC_ENV/ac_stuff/configure
		date 
		time make test
		date
		cd unit_test
		time isdc_dircmp --cwdtmp out outref
		date
		breaksw

	case planckl1:
	case planckaux:
	case planckdr:
		repeat 3 echo ""
		echo "Running $1 unit_test on $HOST"
		repeat 3 echo ""
		source $LHEASOFT/lhea-init.csh
		cd /home/isdc_guest/isdc_int/planck/$1
		date 
		time make test
		date
		cd unit_test
		time isdc_dircmp --cwdtmp out outref
		date
		breaksw

	default:
		echo "$1 not a valid pipeline"
		echo $usage
		echo

endsw


