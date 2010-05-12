#!/bin/sh
eval 'exec perl -x $0 ${1+"$@"}'
#!perl -w

use strict;

my $filename = "";
my $suffix = "";
my $dryrun;
#my $FUNCNAME = "addsuffix";		replaced with $0
my $FUNCVERSION = "1.0";

exit unless ( $#ARGV >= 0 );

#	loop through all parameters that begin with - until one doesn't have a leading - 
if ( defined ($ARGV[0]) ) {
	while ($_ = $ARGV[0], /^-.*/) {
		if ( /-h/ ) {
			print "\n\n"
				."Usage:  $0  [options] file(s)\n"
				."\n"
				."  -v, --v, --version -> version number\n"
				."  --dry-run          -> don't really do anything\n"
				."  --suffix new_suf   -> append new_suf to the ROOT of the filename\n"
				."  -h, --h, --help    -> this help message\n"
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
		elsif ( /-s/ ) {
			shift @ARGV;
			$suffix = $ARGV[0];
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

	#	090424 - added the ? after the . cause caused problems on files without extensions (ie. README)
	my ( $root, $ext ) = ( $filename =~ /^(.*)\.?(.*)$/ );

	my $newfilename;
	($newfilename = $root ) =~ s/$/$suffix/;
	if( $ext ){
		$newfilename .= ".";
		$newfilename .= "$ext";
	}

	print "$newfilename\n";

	rename $filename, $newfilename unless $dryrun;

	shift @ARGV;
}     # while options left on the command line

exit;



#	last line
