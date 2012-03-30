#!/usr/bin/perl -w

use strict;

my $FUNCNAME = "rootscriptsearch.pl";
my $FUNCVERSION = "1.0";

#	loop through all parameters that begin with - until one doesn't have a leading - 
if ( defined ($ARGV[0]) ) {
	while ($_ = $ARGV[0], /^-.*/) {
		if ( /-h/ ) {
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

my %comps;

foreach ( `find $ENV{ISDC_ENV}/*-sw -name \*.C -exec grep ISDCTask {} \\\; ` ) {
#foreach ( `find $ENV{ISDC_ENV}/analysis-sw -name \*.C -exec grep ISDCTask {} \\\; ` ) {
	chomp;
	#ISDCTask o_cor_science("o_cor_science");
	next unless ( /\s*ISDCTask\s*(\w+)\(\s*"\1"\s*\)/ );
	#	print "$1 - $_\n";
	$comps{$1} = 1;
}

foreach ( sort {$a cmp $b} ( keys %comps ) ) {
	print "$_ - ok\n" if ( -e "$ENV{ISDC_ENV}/bin/$_" );
	print "$_ - NOT INSTALLED!\n" unless ( -e "$ENV{ISDC_ENV}/bin/$_" );
}

exit;

