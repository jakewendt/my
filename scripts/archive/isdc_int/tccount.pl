#!/usr/bin/perl -w

use strict;
use File::Basename;

my $filename = "";
my $FUNCNAME = "template";
my $FUNCVERSION = "0.0";

#exit unless ( $#ARGV >= 0 );

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

#	exit unless ( $#ARGV >= 0 );

#	loop through all the rest after the first without a leading -

my %count;
foreach my $olf ( glob ( "new/*" ) ) {
	#	print "$olf\n";
	$olf = basename($olf);
	print "------------\n$olf\n";
	foreach my $dir ( "OLFMergeOut", "new" ) {
		print "$dir/$olf\t";
		$count{$dir} = `grep TIME_CORRELATION $dir/$olf | wc -l`;
		chomp $count{$dir};
		print "$count{$dir}\t";
		if ( $dir =~ /new/ ) {
			if ( $count{"OLFMergeOut"} != $count{"new"} ) {
				print "<-----------------------";
			}
		}
	}
	print "\n";
}

exit;



