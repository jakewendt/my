#!/usr/bin/perl -w

use File::Basename;
use strict;

# exit unless ( $#ARGV >= 0 );

my $scw = "";
my $FUNCNAME = "RevIDXCheck.pl";
my $FUNCVERSION = "1.0";

$ENV{COMMONLOGFILE} = "+$ENV{HOME}/common_log.txt";

#	loop through all parameters that begin with - until one doesn't have a leading - 
if ( defined ($ARGV[0]) ) {
	while ($_ = $ARGV[0], /^-.*/) {
		if ($_ eq "-h"          ||
			$_ eq "--h"             ||
			$_ eq "--help") {
				print 
					"\n\n"
					."Usage:  $FUNCNAME  [options] file(s)\n"
					."\n"
					."  -v, --v, --version -> version number\n"
					."  -h, --h, --help    -> this help message\n"
					."     by default, parcheck only compares parameter names\n"
					."\n\n"
				; # closing semi-colon
				exit 0;
			}
		elsif ($_ eq "-v"               ||
			$_ eq "--v"                     ||
			$_ eq "--version") {
				print "Log_1  : Version : $FUNCNAME $FUNCVERSION\n";
				exit 0;
		}
		else {  # all other cases
			print "ERROR: unrecognized option +$ARGV[0]+.  Aborting...\n";
			print "\n";
			exit 1;
		}
		shift @ARGV;
	}     # while options left on the command line
} else {
		#	Or else what?
}

# exit unless ( $#ARGV >= 0 );


foreach my $idx ( `/bin/ls $ENV{REP_BASE_PROD}/idx/rev/*IDX.fits` ) {
	chomp $idx;
	print "Checking ${idx}....\n";

	system "dal_list ${idx}+1";
	die "ERROR : $?" if ( $? );

}

exit;



