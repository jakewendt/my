#!/usr/bin/perl -w

use strict;

my $filename = "";
my $extension = "";
my $site = "";
my $FUNCNAME = "grabhref";
my $FUNCVERSION = "1.0";

exit unless ( $#ARGV >= 0 );

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
		elsif ($_ eq "-s"               ||
			$_ eq "--s"                     ||
			$_ eq "--site") {
				shift @ARGV;
				$site = $ARGV[0];
		}
		elsif ($_ eq "-e"               ||
			$_ eq "--e"                     ||
			$_ eq "--extension") {
				shift @ARGV;
				$extension = $ARGV[0];
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

exit unless ( $#ARGV >= 0 );

#	loop through all the rest after the first without a leading -
while ( $ARGV[0] ) {
	$filename = $ARGV[0];
	#print $filename."\n";

	my @href;
	open SOURCE, $filename;
	while (<SOURCE>) {
		chomp;
		@href = ( /href\=\"([\w\-\/\.\d]+\.${extension})\"/g );
		#print $_;
		foreach ( @href ) {
			print "$site/$_\n";
		}
	}
	close SOURCE;

	shift @ARGV;
}     # while options left on the command line

exit;



