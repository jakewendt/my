#!/isdc/sw/perl/prod/WS/prod/bin/perl -w
#
#  
#        Script to generate unit tests from raw packet data
#
#
use strict;

my $system = "nrt";
my $date = MyTime();
my $revno;
my $scwid;
my $trigger;
my $type;
my $file;
$| = 1;

########
#  Read in command line args, if any:  
########
foreach (@ARGV) {
	if (/--h/) {
		print "\nUSAGE:  mk_unit_testdata.pl [--h] [--system=cons]\n\n";
		print "\tThe default behavior is to create NRT unit tests.\n\n";
		print	"\tThe following environment variables are used:\n"
				."\t\tREP_BASE_PROD\n"
				."\t\tREP_BASE_TM\n"
				."\t\tISDC_SITE\n"
				."\t\tOPUS_WORK\n"
				."\t\tISDC_ENV\n\n";
		print "\tYou should first:\n"
				."\t\t- set up the Preproc.prm file under \$ISDC_SITE/run/work/nrt_pp/\n"
				."\t\t\twith the settings needed aside from first and last TM files\n"
				."\t\t- untar the old unit test data cleanly under \$ISDC_OPUS.\n"
				."\t\t- set up REP_BASE_PROD with links to the correct auxiliary and IC data\n"
				."\t\t- set up OPUS_WORK using isdc_opus_install.csh\n";
		exit;
	}
	
	elsif (/--system=cons/) {
		$system = "cons";
	}
	else {
		print "Unknown argument : $_\n";
		exit;
	}
}

print "\n\n>>>>>>>     Generating unit tests for ${system}\n";
print ">>>>>>>\n";

#  Useful in debugging and recovering from errors:
goto START;



START:





########################
#  Do some checks first.
########################

#  Does the Preproc.prm exist?  
die ">>>>>>>     ERROR:  please set up \$ISDC_SITE/run/work/${system}_pp/Preproc.prm\n" 
	unless (-e "$ENV{ISDC_SITE}/run/work/${system}_pp/Preproc.prm" );

#	040413 - Jake - I don't understand why this is needed?  
#	I do think that a check of the test_data dir is warranted though so I am creating one.
#  Are the unit test directories ready?  Just check that outref exists, 
#   but not out or outref.new, for example.
#	die ">>>>>>>     ERROR:  please set up the current \$ISDC_OPUS/*/unit_test directories\n" 
#		if (  (`ls $ENV{ISDC_OPUS}/${system}\{input,scw,rev\}/unit_test/out $ENV{ISDC_OPUS}/${system}\{input,scw,rev\}/unit_test/outref.new 2> /dev/null`) 
#			|| !( (-d "$ENV{ISDC_OPUS}/${system}input/unit_test/outref" ) 
#			&& (-d "$ENV{ISDC_OPUS}/${system}scw/unit_test/outref" ) 
#			&& (-d "$ENV{ISDC_OPUS}/${system}rev/unit_test/outref" ) ) );

#	040413 - Jake - added check for test_data dirs
#  Are the unit test directories ready?  Just check that test_data exists, 
#   but not test_data.new, for example.
die ">>>>>>>     ERROR:  please set up the current \$ISDC_OPUS/*/unit_test directories\n" 
	if (  (`ls $ENV{ISDC_OPUS}/${system}\{input,scw,rev\}/unit_test/test_data.new 2> /dev/null`) 
		|| !( (-d "$ENV{ISDC_OPUS}/${system}input/unit_test/test_data" ) 
		&& (-d "$ENV{ISDC_OPUS}/${system}scw/unit_test/test_data" ) 
		&& (-d "$ENV{ISDC_OPUS}/${system}rev/unit_test/test_data" ) ) );

#  Is REP_BASE_PROD ready?
die ">>>>>>>     ERROR:  please set up the current \$REP_BASE_PROD\n" 
	unless ( (-e "$ENV{REP_BASE_PROD}/aux" ) 
		&& (-e "$ENV{REP_BASE_PROD}/ic" )  
		&& (-e "$ENV{REP_BASE_PROD}/idx/ic" )  
		&& (!-d "$ENV{REP_BASE_PROD}/scw" ) );

#  Is OPUS_WORK ready?
die ">>>>>>>     ERROR:  please run isdc_opus_install.csh\n" 
	unless (  (-e "$ENV{OPUS_WORK}/${system}input" ) 
		&& (-e "$ENV{OPUS_WORK}/${system}scw" ) 
		&& (-e "$ENV{OPUS_WORK}/${system}rev" ) 
		&& !( (`ls $ENV{OPUS_WORK}/${system}input/input/ 2> /dev/null`) 
		|| (`ls $ENV{OPUS_WORK}/${system}rev/input/ 2> /dev/null`) ) );

#  Is REP_BASE_TM ready?
die ">>>>>>>     ERROR:  please set REP_BASE_TM to the correct location\n" 
	unless (-d "$ENV{REP_BASE_TM}" );

#  Is aux set correctly?  Error if ( nrt && !000) or ( cons && !001 ):
die ">>>>>>>     ERROR:  please choose the right aux directory for system $system\n" 
	if ( ( ($system =~ /nrt/) 
		&& (!-d "$ENV{REP_BASE_PROD}/aux/adp/0025.000" ) ) 
		|| ( ($system =~ /cons/) 
		&& (!-d "$ENV{REP_BASE_PROD}/aux/adp/0025.001" ) ) );

#	The duplicate dirs of 0025 are not set right.  Probably is a big.0025 and 0025 inside it.  Should be omc.0025 and 0025.
die ">>>>>>>     ERROR:  REP_BASE_TM not set up right\n>>>>>>>     It should contain 0025(big) and omc.0025(small)\n" 
	if ( ( ! -d "$ENV{REP_BASE_TM}/0025" ) 
		|| ( ! -d "$ENV{REP_BASE_TM}/omc.0025" ) );

################################################################
#
#        Running Preproc
#
################################################################

foreach $revno ( "0003", "0004", "0013", "0014", "0024", "0025", "0036" ) {
	print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
	print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
	print ">>>>>>>     Running Preproc on revolution $revno\n";
	print ">>>>>>>\n";
#	&RunCom ( "/home/isdc_guest/isdc_int/local/bin/pp_wrapper.sh --system=${system} $revno" );
	&RunCom ( "/home/isdc/wendt/local/scripts/isdc_int/pp_wrapper.sh --system=${system} $revno" );
}

print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
print ">>>>>>     Running Preproc on revolution 0025 again for OMC dark current files\n";

print ">>>>>>>\n";
#  0025 is more complicated;  need two distinct periods in this, the beginning with most of
#   the data, and one little a day later for OMC dark current calibrations.  So need two different
#   versions of the TM dirs, of the output dirs, and trigger dirs

#  Move tm dirs
&RunCom ( "mv $ENV{REP_BASE_TM}/0025 $ENV{REP_BASE_TM}/big.0025" );
&RunCom ( "mv $ENV{REP_BASE_TM}/omc.0025 $ENV{REP_BASE_TM}/0025" );

#  Move out dir aside
&RunCom ( "mv $ENV{REP_BASE_PROD}/scw/0025 $ENV{REP_BASE_PROD}/scw/big.0025" );

#  Move triggers temporarily
&RunCom ( "mv $ENV{OPUS_WORK}/${system}input/input  $ENV{OPUS_WORK}/${system}input/input.bak" );
&RunCom ( "mkdir $ENV{OPUS_WORK}/${system}input/input" );
&RunCom ( "mv $ENV{OPUS_WORK}/${system}rev/input  $ENV{OPUS_WORK}/${system}rev/input.bak" );
&RunCom ( "mkdir $ENV{OPUS_WORK}/${system}rev/input" );

#
#  Run preproc on 0025 again;  only one TM file.
# 
#  (Have to remove prm file first, or script won't recreate it
&RunCom ( "rm $ENV{ISDC_SITE}/run/work/${system}_pp/Preproc.prm.0025" );
#&RunCom ( "/home/isdc_guest/isdc_int/local/bin/pp_wrapper.sh --system=${system} 0025" );
&RunCom ( "/home/isdc/wendt/local/scripts/isdc_int/pp_wrapper.sh --system=${system} 0025" );


#  Move dark current files into "real" 0025 dir, and remove junk one
&RunCom ( "mv $ENV{REP_BASE_PROD}/scw/0025/rev.000/raw/omc_raw_dark_20021228074420_00.fits "
	." $ENV{REP_BASE_PROD}/scw/big.0025/rev.000/raw/." );
&RunCom ( "mv $ENV{REP_BASE_PROD}/scw/0025 $ENV{REP_BASE_PROD}/scw/junk.0025" );
&RunCom ( "mv $ENV{REP_BASE_PROD}/scw/big.0025 $ENV{REP_BASE_PROD}/scw/0025" );


#  Remove scw triggers, which are useless
&RunCom ( "mv $ENV{OPUS_WORK}/${system}input/input $ENV{OPUS_WORK}/${system}input/input.junk" );
#  Move back old trigger dir
&RunCom ( "mv $ENV{OPUS_WORK}/${system}input/input.bak  $ENV{OPUS_WORK}/${system}input/input" );

#  Move only OMC dark current triggers 
&RunCom ( "mv $ENV{OPUS_WORK}/${system}rev/input/0025_20021228074420_00_odc.trigger "
	." $ENV{OPUS_WORK}/${system}rev/input.bak" );
&RunCom ( "mv $ENV{OPUS_WORK}/${system}rev/input  $ENV{OPUS_WORK}/${system}rev/input.junk" );
#  Move back old trigger dir, now with OMC dark current triggers
&RunCom ( "mv $ENV{OPUS_WORK}/${system}rev/input.bak  $ENV{OPUS_WORK}/${system}rev/input" );


#  Mv tm files back to start
&RunCom ( "mv $ENV{REP_BASE_TM}/0025 $ENV{REP_BASE_TM}/omc.0025" );
&RunCom ( "mv $ENV{REP_BASE_TM}/big.0025 $ENV{REP_BASE_TM}/0025" );

########################
#  Tar the raw data
########################


&RunCom ( "mv /isdc/integration/isdc_int/data/Preproc/unit_test_raw.tgz "
	." /isdc/integration/isdc_int/data/Preproc/unit_test_raw.tgz.old_${date}" );

chdir "$ENV{REP_BASE_PROD}" or die ">>>>>>>     ERROR:  cannot chdir to $ENV{REP_BASE_PROD}!\n";

&RunCom ( "tar cf - scw | gzip > /isdc/integration/isdc_int/data/Preproc/unit_test_raw.tgz" );
#&RunCom ( "tar czf /isdc/integration/isdc_int/data/Preproc/unit_test_raw.tgz scw" );


################################################################
#
#        Creating Input pipeline test_data
#
################################################################

&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}input/unit_test/test_data.new/scw/0025" );

#
#  002500000041 has no SPI.-SHK?-TMP, while 51 does

&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}input/unit_test/opus_work.new/${system}input/input" );
foreach $scwid ( "002500000041","002500000051" ) {
	&RunCom ( "cp -r $ENV{REP_BASE_PROD}/scw/0025/${scwid}.000 "
		." $ENV{ISDC_OPUS}/${system}input/unit_test/test_data.new/scw/0025/" );
	&RunCom ( "touch $ENV{ISDC_OPUS}/${system}input/unit_test/opus_work.new/${system}input/input/${scwid}.trigger" );
}



#########
#        Run Input pipeline for other science windows needed:
#########


#	somehow, if a previous try fails a trigger ends up here as trigger_work
#	then another trigger is created for the same scw
#	but when nrtscw is run on that scw it gets "confused"
#	I don't understand where the _work trigger is coming from
#	as I check for it before I start, and then somehow
#	it appears???
&RunCom ( "/bin/ls -l $ENV{OPUS_WORK}/${system}scw/input/" );		#	040611 - Jake - DEBUG - for some reason a trigger is being created early?


foreach $scwid ( "002400050010", "002400050020", "002400050031",
		"002500000041", "002500000051", "002500000061", "002500010010"  ) {
	&RunCom ( "$ENV{ISDC_OPUS}/pipeline_lib/opus_wrapper ${system}input $scwid" );
	&RunCom ( "osf_update -p ${system}input -f $scwid -s ccc" );
	&RunCom ( "/bin/ls -l $ENV{OPUS_WORK}/${system}scw/input/" );		#	040611 - Jake - DEBUG - for some reason a trigger is being created early?
}

################################################################
#
#        Create ScW pipeline test_data:
#
################################################################

&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0024" );
&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0025" );
&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}scw/unit_test/opus_work.new/${system}scw/input" );

# 0024
foreach $scwid ( "002400050010", "002400050020", "002400050031" ) {
	&RunCom ( "cp -r $ENV{REP_BASE_PROD}/scw/0024/${scwid}.000 "
		." $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0024" );
}
&RunCom ( "touch $ENV{ISDC_OPUS}/${system}scw/unit_test/opus_work.new/${system}scw/input/002400050031.trigger" );

# 0025
foreach $scwid ( "002500000041", "002500000051", "002500000061", "002500010010" ) {
	&RunCom ( "cp -r $ENV{REP_BASE_PROD}/scw/0025/${scwid}.000 "
		." $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0025" );
}
&RunCom ( "touch $ENV{ISDC_OPUS}/${system}scw/unit_test/opus_work.new/${system}scw/input/002500000051.trigger" );
&RunCom ( "touch $ENV{ISDC_OPUS}/${system}scw/unit_test/opus_work.new/${system}scw/input/002500000061.trigger" );
&RunCom ( "touch $ENV{ISDC_OPUS}/${system}scw/unit_test/opus_work.new/${system}scw/input/002500010010.trigger" );

#  Fudge PREVSWID for 002500000041 
&RunCom ( "chmod +w $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0025/002500000041.000/swg_raw.fits" );
&RunCom ( "dal_attr indol=$ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0025/002500000041.000/swg_raw.fits[1] "
	." keynam=PREVSWID action=WRITE type=DAL_CHAR value_s=000000000000 comment=\"fudged for ${system}scw unit test\"" );
&RunCom ( "chmod -w $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0025/002500000041.000/swg_raw.fits" );


#########
#
#        Run Rev pipeline for those needed by ScW:
#				(	Maybe I need to copy some stuff out before running this? - Jake - 040518 )
#
#########

foreach $file ( "0024_20021227000251_00_irn", "0025_20021227074907_00_idp", 
		"0025_20021227053820_00_irn", "0036_20030131204711_00_idp", 
		"0025_20021227080902_00_jm2", "0025_20021227084726_00_jm2", "0025_20021227091814_00_jm2", 
		"0025_20021227084902_00_jm1", "0025_20021227092310_00_jm1", "0025_20021227081542_00_jm1" ) {
	&RunCom ( "$ENV{ISDC_OPUS}/pipeline_lib/opus_wrapper ${system}rev $file" );
	&RunCom ( "osf_update -p ${system}rev -f $file -s ccc" );
}



#	040618 - Jake - it would be nice if we could run iii_prep here before the scw 
#	pipeline stuff but I haven't gotten around to it just yet.



#########
#
#        Run ScW pipeline for those needed by Rev:
#				(	Maybe I need to copy some stuff out before running this? - Jake - 040518 )
#
#########
#
# How many do we really need????????????

foreach $scwid ( "002400050010", "002500000051"  ) {
	&RunCom ( "$ENV{ISDC_OPUS}/pipeline_lib/opus_wrapper ${system}scw $scwid" );
	&RunCom ( "osf_update -p ${system}scw -f $scwid -s ccccc" );	#	040513 - Jake - cccccc to ccccc
}


#########
#
#        Run more Rev pipeline for those needed by ScW: ( 040611 - Jake )
#
#########
#	040611 - Jake - this creates the spi_gain_coeff.fits files need for spi_gain_corr in nswcor.pl (hopefully)
#		needs to be run after at least nswdp.pl, cuz that creates the swg.fits files
foreach $file ( "0024_iii_prep", "0025_iii_prep" ) {		#	040611 - Jake - added the iii_prep's to see if it works
	&RunCom ( "$ENV{ISDC_OPUS}/pipeline_lib/opus_wrapper ${system}rev $file" );
	&RunCom ( "osf_update -p ${system}rev -f $file -s ccc" );
}


################################################################
#
#        Create Rev pipeline test_data:
#
################################################################

foreach $revno ( "0003","0004","0013","0014","0024","0025","0036" ) {
	&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/scw/${revno}/rev.000/raw" );
}
&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}rev/unit_test/opus_work.new/${system}rev/input/" );

# 0003
foreach $file ( "spi_raw_dump_20021023151210_00.fits" ) {
	&RunCom ( "cp -r $ENV{REP_BASE_PROD}/scw/0003/rev.000/raw/$file "
		." $ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/scw/0003/rev.000/raw/" );
}

# 0004
foreach $file ( "omc_raw_dump_20021027171324_00.fits" ) {
	&RunCom ( "cp -r $ENV{REP_BASE_PROD}/scw/0004/rev.000/raw/$file "
		." $ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/scw/0004/rev.000/raw/" );
}

# 0013
foreach $file ( "spi_raw_dfdump_20021122192241_00.fits" ) {
	&RunCom ( "cp -r $ENV{REP_BASE_PROD}/scw/0013/rev.000/raw/$file "
		." $ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/scw/0013/rev.000/raw/" );
}

# 0014
foreach $file ( "jemx*" ) {
	&RunCom ( "cp -r $ENV{REP_BASE_PROD}/scw/0014/rev.000/raw/$file "
		." $ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/scw/0014/rev.000/raw/" );
}

# 0024
#	040322 - Jake - added isgri_raw_cal_20021226220133_00.fits so can test irc triggers and SCREW 791
foreach $file ( "*tver*", "ibis_raw_veto_20021226220948_00.fits", "irem_*",
		"sc_raw_tref*", "isgri_raw_noise_2002122623*", "isgri_raw_cal_20021226220133_00.fits" ) {
	&RunCom ( "cp -r $ENV{REP_BASE_PROD}/scw/0024/rev.000/raw/$file "
		." $ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/scw/0024/rev.000/raw/" );
}

# 0025
#	040518 - Jake - added isgri_raw_cal_20021227081604_00.fits bc changed from 0024_arc_prep to 0025
foreach $file ( "omc_raw_dark_20021228074420_00.fits", "jemx*ecal*", "picsit*", 
	"ibis_raw_veto*", "isgri_raw_noise_20021227073956_00.fits", "isgri_raw_noise_20021227081019_00.fits",
	"irem_raw_20021227060629_00.fits", "irem_raw_20021227070629_00.fits", "jemx1_raw_frss_20021227081542_00.fits",
	"jemx2_raw_frss_20021227080902_00.fits", "omc_raw_dark_20021228074420_00.fits",
	"ibis_raw_dump_20021227074907_00.fits", "isgri_raw_cal_20021227081604_00.fits" ) {

	&RunCom ( "cp -r $ENV{REP_BASE_PROD}/scw/0025/rev.000/raw/$file "
		." $ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/scw/0025/rev.000/raw/" );

	#	040517 - Jake
	#	adding the chmod because they get set to read-only after their earlier processing 
	#	(its easier just to do it for all even though already +w)
	#	jemx?_raw_frss_* and ibis_raw_dump*
	&RunCom ( "chmod +w $ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/scw/0025/rev.000/raw/$file" );
}

# 0036
foreach $file ( "ibis_raw_dump_20030131204711_00.fits" ) {
	&RunCom ( "cp -r $ENV{REP_BASE_PROD}/scw/0036/rev.000/raw/$file "
		." $ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/scw/0036/rev.000/raw/" );

	#	040517 - Jake
	#	adding the chmod because they get set to read-only after their earlier processing 
	#	(its easier just to do it for all even though already +w)
	#	jemx?_raw_frss_* and ibis_raw_dump*
	&RunCom ( "chmod +w $ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/scw/0036/rev.000/raw/$file" );
}

foreach $revno ( "0003", "0004", "0013", "0014", "0024", "0025", "0036" ) {
	#	040322 - Jake - Why run this twice?  Hmm, interesting.  Can't hurt I guess.
#	&RunCom ( "/home/isdc_guest/isdc_int/local/bin/mktrigs.pl "
	&RunCom ( "/home/isdc/wendt/local/scripts/isdc_int/mktrigs.pl "
		." $ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/scw/${revno}/rev.000/raw/ "
		." $ENV{ISDC_OPUS}/${system}rev/unit_test/opus_work.new/${system}rev/input/ rev" );
#	&RunCom ( "/home/isdc_guest/isdc_int/local/bin/mktrigs.pl "
	&RunCom ( "/home/isdc/wendt/local/scripts/isdc_int/mktrigs.pl "
		." $ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/scw/${revno}/rev.000/raw/ "
		." $ENV{ISDC_OPUS}/${system}rev/unit_test/opus_work.new/${system}rev/input/ rev" );
}

#  Copy science windows needed for IREM:
&RunCom ( "cp -r $ENV{REP_BASE_PROD}/scw/0024/0024*.000 "
	." $ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/scw/0024" );
foreach $scwid ( "002500000041", "002500000051" ) {
	&RunCom ( "cp -r $ENV{REP_BASE_PROD}/scw/0025/${scwid}.000 "
	." $ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/scw/0025" );
}


#
#
#	"Run Rev pipeline for those needed by ScW:" USED TO BE HERE until the introduction of the correction stuff
#
#



################################################################
#
#        Add Rev results to Scw pipeline test_data:
#
################################################################



#  For rev 24, only put picsit_fault_list
&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0024/rev.000/cfg/" );
#  PICsIT fault list should have come out of dump run above
&RunCom ( "cp $ENV{REP_BASE_PROD}/scw/0036/rev.000/cfg/* "
	." $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0024/rev.000/cfg/" );

#  TO BE FIXED:  can't use picsit_fault_list now or get bad results from
#   ibis_comp_evts_tag, different every time.  So for now, move it:
&RunCom ( "mv $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0024/rev.000/cfg/picsit_fault_list* "
	." $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0024/rev.000/cfg/back.picsit_fault_list.fits" );
#  For rev 25, copy everything
&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0025/rev.000/raw/" );
&RunCom ( "cp $ENV{REP_BASE_PROD}/scw/0025/rev.000/raw/* "
	." $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0025/rev.000/raw/" );
&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0025/rev.000/idx/" );
&RunCom ( "cp $ENV{REP_BASE_PROD}/scw/0025/rev.000/idx/* "
	." $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0025/rev.000/idx/" );
&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0025/rev.000/prp/" );
&RunCom ( "cp $ENV{REP_BASE_PROD}/scw/0025/rev.000/prp/* "
	." $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0025/rev.000/prp/" );
&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0025/rev.000/cfg/" );
&RunCom ( "cp $ENV{REP_BASE_PROD}/scw/0025/rev.000/cfg/* "
	." $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0025/rev.000/cfg/" );

#	040427 - Jake - added to test the frss for j_correction
&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0024/rev.000/aca/" );
&RunCom ( "cp $ENV{REP_BASE_PROD}/scw/0024/rev.000/aca/* "
	." $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0024/rev.000/aca/" );
&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0025/rev.000/aca/" );
&RunCom ( "cp $ENV{REP_BASE_PROD}/scw/0025/rev.000/aca/* "
	." $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/0025/rev.000/aca/" );


################################################################
#
#  Create indices:
#
################################################################

#  Rev raw
&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/idx/scw/raw/" );

chdir "$ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/idx/scw/raw"
	or die ">>>>>>>    ERROR:  cannot chdir to $ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/idx/scw/raw";

&RunCom ( "idx_add index=GNRL-SCWG-GRP-IDX.fits template=GNRL-SCWG-GRP-IDX.tpl element=../../../scw/0024/002400000012.000/swg_raw.fits[1]" );

foreach $scwid ( "002400050010","002400050020","002400050031","002400090010" ) {
	&RunCom ( "idx_add index=GNRL-SCWG-GRP-IDX.fits[1] template= element=../../../scw/0024/${scwid}.000/swg_raw.fits[1]" );
}
foreach $scwid ( "002500000041","002500000051" ) {
	&RunCom ( "idx_add index=GNRL-SCWG-GRP-IDX.fits[1] template= element=../../../scw/0025/${scwid}.000/swg_raw.fits[1]" );
}


#	040225 - Jake - BEGIN modifications for reprocessing 
#  Rev osm	#	040427 - Jake - not really osm as I am removing the osm dir
&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/idx/scw/" );

chdir "$ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/idx/scw" 
	or die ">>>>>>>    ERROR:  cannot chdir to $ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/idx/scw";

&RunCom ( "idx_add index=GNRL-SCWG-GRP-IDX.fits    template=GNRL-SCWG-GRP-IDX.tpl element=../../scw/0024/002400050010.000/swg.fits[1]" );
&RunCom ( "idx_add index=GNRL-SCWG-GRP-IDX.fits[1] template=                      element=../../scw/0025/002500000051.000/swg.fits[1]" );
#	040225 - Jake - END modifications for reprocessing 




# ScW
&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/idx/scw/raw/" );

chdir "$ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/idx/scw/raw" 
	or die ">>>>>>>    ERROR:  cannot chdir to $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/idx/scw/raw";

&RunCom ( "idx_add index=GNRL-SCWG-GRP-IDX.fits template=GNRL-SCWG-GRP-IDX.tpl element=../../../scw/0024/002400050010.000/swg_raw.fits[1]" );
foreach $scwid ( "002400050020","002400050031" ) {
	&RunCom ( "idx_add index=GNRL-SCWG-GRP-IDX.fits[1] template= element=../../../scw/0024/${scwid}.000/swg_raw.fits[1]" );
}
foreach $scwid ( "002500000041","002500000051","002500000061","002500010010" ) {
	&RunCom ( "idx_add index=GNRL-SCWG-GRP-IDX.fits[1] template= element=../../../scw/0025/${scwid}.000/swg_raw.fits[1]" );
}



################################################################
#
#  Copy README.data, aux:	
#
#	040415 - Jake - adding a few other things here for SCREW 1344
#	040714 - Jake - the aux/adp/0*/*fits files have been gzipped to
#							match what will be in the pipelines (SCREW 1479)
#
################################################################
#	050104 - Changed mv's to cp -p's so isdc_dircmp doesn't report "unique" files
foreach $type ( "input", "scw", "rev" ) {
	&RunCom ( "cp -pr $ENV{ISDC_OPUS}/${system}${type}/unit_test/test_data/aux "
		." $ENV{ISDC_OPUS}/${system}${type}/unit_test/test_data.new" );
	&RunCom ( "cp -p $ENV{ISDC_OPUS}/${system}${type}/unit_test/test_data/README.data "
		." $ENV{ISDC_OPUS}/${system}${type}/unit_test/test_data.new" );

	#	040531 - Jake - SPR 3650 - add ignored_errors.cfg to nrtscw and consscw to deal with *_correction errors
	if ( -r "$ENV{ISDC_OPUS}/${system}${type}/unit_test/opus_work/opus/ignored_errors.cfg" ) {
		&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}${type}/unit_test/opus_work.new/opus/" );
		&RunCom ( "cp -p $ENV{ISDC_OPUS}/${system}${type}/unit_test/opus_work/opus/ignored_errors.cfg "
			." $ENV{ISDC_OPUS}/${system}${type}/unit_test/opus_work.new/opus/" );
	}

	if ( $type =~ /rev/ ) {											#	040415 - Jake - SCREW 1344
		&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}${type}/unit_test/test_data.new/idx/rev" );
		&RunCom ( "mkdir -p $ENV{ISDC_OPUS}/${system}${type}/unit_test/test_data.new/scw/0024/rev.000/cfg" );

		#	I'm not sure that I could create this on the fly, so I just copy.  May be a problem.
		&RunCom ( "cp -p $ENV{ISDC_OPUS}/${system}${type}/unit_test/test_data/scw/0024/rev.000/cfg/isgri_context_dead_024.fits "
			." $ENV{ISDC_OPUS}/${system}${type}/unit_test/test_data.new/scw/0024/rev.000/cfg/" );

		chdir "$ENV{ISDC_OPUS}/${system}${type}/unit_test/test_data.new/idx/rev" or 
			die ">>>>>>>    ERROR:  cannot chdir to $ENV{ISDC_OPUS}/${system}${type}/unit_test/test_data.new/idx/rev";
		&RunCom ( "idx_add index=ISGR-DEAD-CFG-IDX_024.fits template=ISGR-DEAD-CFG-IDX.tpl element=../../scw/0024/rev.000/cfg/isgri_context_dead_024.fits[1]" );
		&RunCom ( "ln -s ISGR-DEAD-CFG-IDX_024.fits ISGR-DEAD-CFG-IDX.fits" );
	}
}

#	rev files should be gzipped as they will be in actual use (added 050128)
&RunCom ( "gzip $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/*/rev.000/*/*.fits" );





#	060103 - Jake - for some reason when doing Preproc 3.8, these weren't gzipped
#		Were they supposed to be as in the old version?
#		Why weren't they?  Did I do it by hand last time?
#		Did I change something in some *fin step to stop them from being gzipped on purpose?
#		SCREW 1693 - no longer gzip raw data.  Pay attention!
#&RunCom ( "gzip $ENV{ISDC_OPUS}/${system}scw/unit_test/test_data.new/scw/*/0*/raw/*.fits" );
#&RunCom ( "gzip $ENV{ISDC_OPUS}/${system}rev/unit_test/test_data.new/scw/*/0*/raw/*.fits" );





################################################################
#
#  Add .done files for Cons
#		Why just for CONS?  
#			because they are only used by crvmon.pl
#		Why just 0024?  Why not 0025?
#			less testing.  I've added them for 0025.
#			I am also going to add pp.done for 0003, 0004, 0013, 0014 and 0036 - 050127
#
################################################################
if ($system =~ /cons/) {
	&RunCom ( "touch $ENV{ISDC_OPUS}/consrev/unit_test/opus_work.new/consrev/input/0003_pp.done" );
	&RunCom ( "touch $ENV{ISDC_OPUS}/consrev/unit_test/opus_work.new/consrev/input/0004_pp.done" );
	&RunCom ( "touch $ENV{ISDC_OPUS}/consrev/unit_test/opus_work.new/consrev/input/0013_pp.done" );
	&RunCom ( "touch $ENV{ISDC_OPUS}/consrev/unit_test/opus_work.new/consrev/input/0014_pp.done" );
	&RunCom ( "touch $ENV{ISDC_OPUS}/consrev/unit_test/opus_work.new/consrev/input/0036_pp.done" );
	&RunCom ( "touch $ENV{ISDC_OPUS}/consrev/unit_test/opus_work.new/consrev/input/0024_pp.done" );
	&RunCom ( "touch $ENV{ISDC_OPUS}/consrev/unit_test/opus_work.new/consrev/input/0024_inp.done" );
	&RunCom ( "touch $ENV{ISDC_OPUS}/consrev/unit_test/opus_work.new/consrev/input/0025_pp.done" );
	&RunCom ( "touch $ENV{ISDC_OPUS}/consrev/unit_test/opus_work.new/consrev/input/0025_inp.done" );
}


################################################################
#
#            DONE
#
################################################################


print ">>>>>>>\n";
print ">>>>>>>     DONE:\n";
print ">>>>>>>\n";
print ">>>>>>>     (Please now update the README.data and tar files by hand.)\n";
print ">>>>>>>\n\n";


################################################################
sub RunCom {
	
	my ($com) = @_;
	
	print ">>>>>>> ".MyTime()." RUNNING:  \'$com\'\n";
	
	my @result = `$com`;
	die ">>>>>>>     ERROR:@result\n" if ($?);
	
	open LOG,">>$ENV{OPUS_WORK}/unit_test_gen.log";
	print LOG "\n\n>>>>>>> ".MyTime()." RUNNING:  \'$com\'\n";
	print LOG @result;
	print LOG ">>>>>>>     DONE.\n\n";
	close LOG;
	
	return;
	
}
################################################################

sub MyTime {
	my @date = localtime;  #  This is GM time on Ops, local on Office.
	$date[5] = $date[5] + 1900;
	$date[4] = $date[4] + 1;
	#  force two digit format
	foreach (@date){ $_ = "0${_}" if ($_ < 10); }
	# removed "(UTC)" when RIL did same;  SPR 493.
	#  my $date = "$date[5]-$date[4]-$date[3]T$date[2]:$date[1]:$date[0](UTC)";
	my $date = "$date[5]-$date[4]-$date[3]T$date[2]:$date[1]:$date[0]";
	return $date;
}
