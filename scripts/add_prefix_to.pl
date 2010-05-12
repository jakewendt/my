#!/bin/sh
eval 'exec perl -x $0 ${1+"$@"}'
#!perl -w

use strict;

my $filename = "";
my $prefix = "";
my $dryrun;
#my $FUNCNAME = "addprefix";	replaced with $0
my $FUNCVERSION = "1.0";

exit unless ( $#ARGV >= 0 );

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
					."  --dry-run          -> don't really do anything\n"
					."  --prefix prefix    -> prefix to be appended to beginning of filename\n"
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
		elsif ( /-p/ ) {
				shift @ARGV;
				$prefix = $ARGV[0];
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

#	loop through all the rest after the first without a leading -
while ( $ARGV[0] ) {
	$filename = $ARGV[0];
	print $filename."\n";

	my $newfilename;
	($newfilename = $filename ) =~ s/^/$prefix/;

	print "$newfilename\n";

	rename $filename, $newfilename unless $dryrun;

	shift @ARGV;
}     # while options left on the command line

exit;
#	last line
