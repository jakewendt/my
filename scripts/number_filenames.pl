#!/bin/sh
eval 'exec perl -x $0 ${1+"$@"}'
#!perl -w

use strict;
use File::Basename;
use POSIX;

my $dryrun;
my $filename = "";
#my $FUNCNAME = "numberfilenames";	#	replaced with $0
my $FUNCVERSION = "1.0";
my $first = 1;
my $newbase = "";
my $power = 1;

exit unless ( $#ARGV >= 0 );

#	print "$#ARGV\n";
#	loop through all parameters that begin with - until one doesn't have a leading - 
if ( defined ($ARGV[0]) ) {
	while ($_ = $ARGV[0], /^-.*/) {
		if ( /-h/ ) {
				print 
					"\n\n"
					."Usage:  $0  [options] file(s)\n"
					."\n"
					."  -v, --v, --version -> version number\n"
					."  -h, --h, --help    -> this help message\n"
					."  --dryrun           -> don't do anything\n"
					."  --first            -> first number\n"
					."  --newbase          -> new basename\n"
					."  --power            -> minimum number of digits\n"
					."\n\n"
				; # closing semi-colon
				exit 0;
			}
		elsif ( /-v/ ) {
				print "Log_1  : Version : $0 $FUNCVERSION\n";
				exit 0;
		}
		elsif ( /-d/) {
				$dryrun++;
		}
		elsif ( /-f/) {
			shift @ARGV;
			$first = $ARGV[0];
		}
		elsif ( /-n/) {
			shift @ARGV;
			$newbase = $ARGV[0];
		}
		elsif ( /-p/) {
			shift @ARGV;
			$power = $ARGV[0];
		}
		else {  # all other cases
			print "ERROR: unrecognized option +$ARGV[0]+.  Aborting...\n";
			print "\n";
			exit 1;
		}
		shift @ARGV;
	}     # while options left on the command line
} else {
	
}

exit unless ( $#ARGV >= 0 );

my $i = $first;
my $log = POSIX::ceil( log($#ARGV+1)/log(10) );
$power = $log unless ( $power > $log );
#	print "$log\n";

#	loop through all the rest after the first without a leading -
while ( $ARGV[0] ) {
	$filename = $ARGV[0];

	my ( $root, $path, $ext ) = File::Basename::fileparse( $filename, '\..*' );
	$i = sprintf ( "%0"."$power"."d", $i );
	my $newfilename = "$path$newbase$i$ext";
	print "mv $filename $newfilename\n";
	die "$newfilename already exists!!!!" if ( -e $newfilename );
	rename $filename, $newfilename unless $dryrun;

	$i++;
	shift @ARGV;
}     # while options left on the command line

exit;


#	last line
