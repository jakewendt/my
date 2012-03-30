#!/usr/bin/perl -w


# I'm not quite sure what this is supposed to do


use strict;
use File::Basename;

my $filename = "";
my $FUNCNAME = "md5wrapper.pl";
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

my $startdir = `pwd`;
chomp $startdir;

while ( $ARGV[0] ) {
	$filename = $ARGV[0];
	print "checking $filename - \n";

	my $basename = basename ($filename);
	my $dirname = dirname ($filename);
	my $failures;

	chdir "${startdir}/${dirname}";

	#	this method of execution allows for immediate line-by-line parsing of output
	open MD5OUT, "md5sum -c $basename |";
	while (<MD5OUT>) {
		print $_;
		$failures++ unless ( /OK/ );
	}
	close MD5OUT;
	print "----------------- $filename ALL OK\n" unless ( $failures );
	print "----------------- $filename PROBLEMS\n" if ( $failures );

	shift @ARGV;
}     # while options left on the command line

exit;

#	last line
