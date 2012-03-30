#! /bin/sh
eval '  exec perl -x $0 ${1+"$@"} '
#! perl -w

use strict;

my $srch_str;
my $radius;
my $ra_source;
my $dec_source;
my $scw_idx;
my $point_ra_str;
my $point_dec_str;
my $scwid_str;
my $command;
my $naxis2;
my $nrows;
my @point_ra;
my @point_dec;
my @scwid;
my $scw_count_dist;
my $scw_count_access;
my $i;
my $slew;
my $distance;
my $near_scw;
my $revno;
my $data_file;
my $data_dir;
my $scw_dol;
my $grep_result;
my $grep_result2;
my @ls_result;
my $found_file;


# script to search through archive index for scws that have a
# pointing direction within "radius" degrees of a user specified
# RA and dec and build a science window dol list in format for
# ISDC software.  There is an optional argument which is passed
# to a grep command, which allows the user to check if they have
# access to the data or if it is private.
# S.Shaw, ISDC, Versoix, 1/12/2003

#defaults


#print $#ARGV;
#print $ARGV;
if($#ARGV < 0){
	print " \n Usage  : scw_srch.pl ra dec radius [search] \n\n";
	print " Script to search through archive index for scws that have a \n";
	print " pointing direction within 'radius' degrees of a user specified\n";
	print " RA and dec and build a science window dol list in format for \n";
	print " ISDC software.  An optional fourth argument can be used to \n";
	print " give a search string that will check the data directory listing.\n";
	print " By default the script searches for existing ISGRI data\n\n";
	print " For example :  scw_srch.pl  288.79 10.94 12. survey\n\n";
	print " Will return a list of ScWs where the pointing direction is within\n" ;
	print " 12 degs. of the GRS1915+105 position for all GPS and GCDE data\n";
	print " with 'survey' group access set.\n\n";
	print " If you enter just one argument it will use this to check all \n";
	print " files for a match regardless of pointing direction.\n\n";
	print " For example : scw_srch.pl survey\n\n";
	print " Will find all GPS and GCDE observations.\n\n";
	print " S.Shaw, ISDC, Versoix, 8/10/2003\n\n";
	exit(0);
}
else {
	if ($#ARGV == 0) {
		$srch_str=$ARGV[0];
		$radius = 999.0;
	} else {
		$ra_source  =$ARGV[0];
		$dec_source =$ARGV[1];
		$radius =$ARGV[2];
	}
}
if ($#ARGV == 3) {$srch_str=$ARGV[3]};

# Define input index file
$scw_idx = "/isdc/arc/rev_1/idx/scw/prp/GNRL-SCWG-GRP-IDX.fits";

# Get pointing directions ad SCWID from Index file with fdump
$point_ra_str  =`fdump $scw_idx STDOUT "RA_SCX" - prhead=no page=no showcol=no showunit=no showrow=n`;
$point_dec_str =`fdump $scw_idx STDOUT "DEC_SCX" - prhead=no page=no showcol=no showunit=no showrow=no`;
$scwid_str     =`fdump $scw_idx STDOUT "SWID" - prhead=no page=no showcol=no showunit=no showrow=no`;

# Some stuff I don't understand to get number of rows in Index file
$command="fkeypar $scw_idx NAXIS2\n";
system($command);
$naxis2=`pget fkeypar value`;
chomp($naxis2);
$nrows=$naxis2;

# Split the results of the fdump to make arrays of RA, dec and SCWs
@point_ra  = split(" ",$point_ra_str);
@point_dec = split(" ",$point_dec_str);
@scwid     = split(" ",$scwid_str);

$scw_count_dist   = 0;
$scw_count_access = 0;

# Main loop over all the files
for ($i = 0; $i < $nrows; $i++){
	#   ignore slews and engineering mode
	$slew = sprintf("%s",substr($scwid[$i],11,1));
	#printf("\n%s", $slew);
	if ($slew == "0") {
	
		#if not interested in pointing direction
		if ($#ARGV == 0) {
			$distance = 0;
		} else {
			#       subroutine lifted out of QLA to do spherical distances
			$distance =&dist($ra_source,$dec_source,$point_ra[$i],$point_dec[$i]);
			#printf("MAIN: %d %s %f %f %f\n", $i,$scwid[$i],$point_ra[$i],,$point_dec[$i],$distance);
		}
	
		#       Test that pointing direction is within radius
		if ($distance < $radius) {
			$scw_count_dist++;
			$near_scw  = $scwid[$i];
			$revno     = sprintf("%s",substr($near_scw, 0,4));
		
			$data_file = sprintf("/isdc/arc/rev_1/scw/%s/%s.001/ibis/prp/isgri_prp_events.fits.gz",$revno,$near_scw);
			$data_dir  = sprintf("/isdc/arc/rev_1/scw/%s/%s.001/ibis/",$revno,$near_scw);
			$scw_dol = sprintf("/isdc/arc/rev_1/scw/%s/%s.001/swg_prp.fits[1]",$revno,$near_scw);
			#       $data_file = sprintf("/isdc/pvphase/nrt/ops_1/scw/%s/%s.000/ibis/prp/isgri_prp_events.fits.gz",$revno,$near_scw);
			#       $data_dir  = sprintf("/isdc/pvphase/nrt/ops_1/scw/%s/%s.000/ibis/",$revno,$near_scw);
			#       $scw_dol = sprintf("/isdc/pvphase/nrt/ops_1/scw/%s/%s.000/swg_prp.fits[1]",$revno,$near_scw);
		
			#           Use grep to search for user, group access etc.
			if ($srch_str){
				$grep_result = `ls -ld $data_dir | grep $srch_str`;
				if ($grep_result){
					$grep_result2 = `ls -l $data_file | grep $srch_str`;
					@ls_result = split(" ",$grep_result2);
					$found_file   = sprintf("%s",$ls_result[8]);
					if ($found_file) {
						$scw_count_access++;
						#printf("found %s\n%s\n\n",$found_file,$scw_dol);
						printf("%s\n",$scw_dol);
					}
					#else {
					# printf("- not found : %s\n\n",$scw_dol);
					#}
				}
				#else
				#{printf( " no access  %s \n",$scw_dol)}# no access to data directory}
			} else {
				printf("%s\n", $scw_dol)
			}# end if search for access
		}# end if dist < rad
	} # end if slew
}# endfor

if ($#ARGV != 3){
printf("\n Finished: %d ScWs within pointing criterea - no access rights were checked.\n",$scw_count_dist);
}
else{
printf("\n Finished: %d ScWs within pointing direction, %d of which matched your %s search criterea\n",$scw_count_dist, $scw_count_access, $srch_str);
}

exit;



sub dist{
	my $debug = 0;
	if ($debug){  printf("DIST: %f %f %f %f \n",$_[0],$_[1],$_[2],$_[3])}
	my $ra1  = $_[0];
	my $dec1 = $_[1];
	my $ra2  = $_[2];
	my $dec2 = $_[3];
	my $x1 = cos($dec1/57.296)*cos($ra1/57.296);
	my $y1 = cos($dec1/57.296)*sin($ra1/57.296);
	my $z1 = sin($dec1/57.296);
	my $x2 = cos($dec2/57.296)*cos($ra2/57.296);
	my $y2 = cos($dec2/57.296)*sin($ra2/57.296);
	my $z2 = sin($dec2/57.296);
	my $ip = $x1*$x2+$y1*$y2+$z1*$z2;

	return(atan2(sqrt(1.0-$ip*$ip),$ip)*57.296);
}

