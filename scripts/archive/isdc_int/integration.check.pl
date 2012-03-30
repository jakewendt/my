#!/usr/bin/perl -w

use strict;

my $filename = "";
my $FUNCNAME = "integration.check.pl";
my $FUNCVERSION = "1.0";

#exit unless ( $#ARGV >= 0 );

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
		elsif ( $_ =~ /-v/ ) {
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

die "PIPELINELIST not set; try setenv PIPELINELIST \"{adp,consinput,consscw,consrev,conssa,consssa,nrtinput,nrtscw,nrtrev,nrtqla}\"\n" 
	unless ( defined ( $ENV{PIPELINELIST} ) );

my $pipelinelist = "$ENV{PIPELINELIST}";
$pipelinelist =~ s/\{|\}//g;
my @list = split ",", $pipelinelist;

foreach ( @list ) {
	my $dircmpout = "$ENV{ISDC_OPUS}/$_/unit_test/tmp_isdc_dircmp/isdc_dircmp.out";
	
	unless ( -e "$dircmpout" ) {
		print "$_ does not exist\n\n";
		next;
	}

	print `/bin/ls -l "$dircmpout"`;
	open CURFILE, "$dircmpout";
	while (<CURFILE>) {
		print "\t$_\n" if ( /isdc_dircmp exit value/ );
	}
	close CURFILE;

}

exit;


