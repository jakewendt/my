#!/usr/bin/perl -s

use FileHandle;

my $filename = "";
my $FUNCNAME = "mdiff.pl";
my $FUNCVERSION = "1.0";

if ( ( $h ) || ( $help ) ) {
	print "Help message.\n";
	exit;
}

my $RED   = "[1;31;43m";
my $RESET = "[0m";

my $max_line_length = 0;
my @filehandles;

#	foreach file read a line.  Use the first file as a baseline and compare others to it.

#	if diffs, print all lines in different color;


#
#	Open all given files
#
while ( $ARGV[0] ) {
	$filename = shift;	#	shift returns ARGV[0] then shifts @ARGV
	print $filename."\n";
	my $fh = FileHandle->new();
	open $fh, "< $filename";
	push @filehandles, $fh;
}





#
#	Close all given files
#
foreach ( @filehandles ) {
	close $_;
}


exit;



