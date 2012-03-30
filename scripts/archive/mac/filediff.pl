#!/usr/bin/perl -w

use strict;

my $filename = "";
my $FUNCNAME = "filediff";
my $FUNCVERSION = "1.0";

exit unless ( $#ARGV >= 0 );

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

die "Need 2 parameters" unless ( $#ARGV == 1 );
die "First dir, $ARGV[0], does not exist." unless ( -d $ARGV[0] );
die "Second dir, $ARGV[1], does not exist." unless ( -d $ARGV[1] );

my $dir1 = $ARGV[0];
my $dir2 = $ARGV[1];

print "Comparing $dir1 and $dir2.\n";

chdir $dir1;

foreach my $filen ( `find . -type f` ) {
	chomp $filen;
	print "$filen\n";
	system ( "diff \"$dir1/$filen\" \"$dir2/$filen\"" );
}

exit;



