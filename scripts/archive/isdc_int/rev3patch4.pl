#!/usr/bin/perl -w

use strict;

my $rev;
my $FUNCNAME = "rev3patch2";
my $FUNCVERSION = "1.0";

unless ( $#ARGV >= 0 ) {
	print "try $FUNCNAME revnum1 [revnum2] [revnum3] ... \n";
	exit;
}

#	loop through all parameters that begin with - until one doesn't have a leading - 
if ( defined ($ARGV[0]) ) {
	while ($_ = $ARGV[0], /^-.*/) {
		if ( /-h/ ) {
			print 
				"\n\n"
				."Usage:  $FUNCNAME  [revnum(s)] \n"
				."\n"
				."  -v, --v, --version -> version number\n"
				."  -h, --h, --help    -> this help message\n"
				."     by default, parcheck only compares parameter names\n"
				."\n\n"
			; # closing semi-colon
			exit 0;
		}
		elsif ( /-v/ ) {
			print "Log_1  : Version : $FUNCNAME $FUNCVERSION\n";
			exit 0;
		}
		else {  # all other cases
			print "ERROR: unrecognized option +$ARGV[0]+.  Aborting...\n";
			print "\n";
#			exit 1;
		}
		shift @ARGV;
	}     # while options left on the command line
} else {
	
}

#	exit unless ( $#ARGV >= 0 );

#$ENV{REP_BASE_PROD} = "/isdc/integration/isdc_int/sw/dev/prod/opus/consssa/unit_test/test_data";
$ENV{REP_BASE_PROD} = "/isdc/isdc_proc/site_01/ops_1";
print "Using REP_BASE_PROD: $ENV{REP_BASE_PROD}\n";
chdir "$ENV{REP_BASE_PROD}/scratch/" or die "Could not chdir $ENV{REP_BASE_PROD}/scratch/";



#	loop through all the rest after the first without a leading -
while ( $ARGV[0] ) {
	$rev = $ARGV[0];
	chdir "$rev" or die "Could not chdir $rev";
	foreach my $scw ( glob ( "0*" ) ) {
		system ( "chmod +w ./$scw" );
		chdir "$scw" or die "Could not chdir $scw";
		system ( "chmod +w swg.fits" );

		my ( $arcscw ) = ( $scw =~ /(\d{12})\.000/ );
		my @arcscws = glob ( "/isdc/arc/rev_2/scw/$rev/$arcscw.*" );
		$arcscw = $arcscws[$#arcscws];

		#	It would be nice if we could remove the empty JMX1-GNRL-GTI-IDX, JMX2-GNRL-GTI-IDX and IBIS-GNRL-GTI-IDX
		#	but as they are not attached, they are really just taking up space.

		foreach ( "1", "2" ) {
			#if ( ( -e "$_.fits.gz" ) && ( ! -l "$_.fits.gz" ) ) {
			if ( -e "jmx${_}_deadtime.fits.gz" ) {
				print "$scw/jmx${_}_deadtime.fits.gz already exists.  Skipping.\n";
			} else {
				if ( -e "$arcscw/jmx${_}_deadtime.fits.gz" ) {
					unlink "jmx${_}_deadtime.fits.gz" if ( -e "jmx${_}_deadtime.fits.gz" );
					print "Dal Cleaning swg.fits\n";
					system ( "dal_clean  backPtrs=1 chatty=2 checkExt=0 checkSum=1 inDOL=swg.fits" );
					print ( "Linking and attaching $arcscw/jmx${_}_deadtime.fits.gz\n" );
					system ( "ln -s $arcscw/jmx${_}_deadtime.fits.gz" );
					system ( "dal_attach Parent=swg.fits Child1=jmx${_}_deadtime.fits[JMX${_}-DEAD-SCP] Child2= Child3= Child4= Child5= " );
				} else {
					print ( "$arcscw/jmx${_}_deadtime.fits.gz not found.\n" );
				}
			}
		}

#		Don't dal_grp_extract because then would possibly have to chmod to other files. (actually probably not.)
#		system ( "dal_grp_extract oDOL=swg.fits iDOL= verbosity=3" );

		system ( "chmod -w swg.fits" );
		chdir ".." or die "Could not chdir ..";
		system ( "chmod -w ." );
	}
	chdir "..";
	shift @ARGV;
}     # while options left on the command line

exit;



