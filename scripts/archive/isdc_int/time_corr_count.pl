#!/usr/bin/perl -w

use strict;
use File::Basename;

my $revno = "";
my $maxcount = 0;
my $mincount = 999999;
my $totcount = 0;
my $numrevs = 0;
my %myhash;
my $filecount;
my $revcount;
my ($root,$path,$suffix);
my $FUNCNAME = "time_corr_count";
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
open MAINOUT, ">>$ENV{HOME}/time_corr_count.out";
open PLOTOUT, ">>$ENV{HOME}/time_corr_count.plot";

#	loop through all the rest after the first without a leading -
while ( $ARGV[0] ) {
	$revno = $ARGV[0];
	$revcount = 0;
	#	print "\n$revno\n";

	foreach my $OLF ( glob ( "/isdc/arc/rev_1/aux/org/$revno/olf/*OLF" ) ) {
		#	print $OLF."\n";
		($root,$path,$suffix) = File::Basename::fileparse($OLF,'\..*');
		print MAINOUT "$revno - $root";

		open CURFILE, "<$OLF";
		$filecount = 0;
		while (<CURFILE>) {
			#print $_;
			$filecount++ if ( /TIME_CORRELATION/ );
		}
		close CURFILE;
		print MAINOUT " - $filecount\n";
		$revcount += $filecount;
	}

	print MAINOUT "$revno has $revcount TIME_CORRELATION records\n\n";
#	${myhash}{revno} = $revcount;
	print PLOTOUT "$revno, $revcount\n";
	$maxcount = $revcount if ( $revcount > $maxcount );
	$mincount = $revcount if ( $revcount < $mincount );
	$totcount += $revcount;
	$numrevs++;

	shift @ARGV;
}     # while options left on the command line

print MAINOUT "\n\n======================================================\n";
print MAINOUT "  Max Records = $maxcount\n";
print MAINOUT "  Min Records = $mincount\n";
print MAINOUT "  Avg Records = ".$totcount/$numrevs."\n";
print MAINOUT "\n";


close MAINOUT;
close PLOTOUT;

exit;

