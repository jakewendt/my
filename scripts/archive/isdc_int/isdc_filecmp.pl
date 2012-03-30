#!/usr/bin/perl -w

use strict;
use File::Basename;

my $FUNCNAME = "isdc_filecmp.pl";
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
					."  --value, --values  -> compares values also\n"
					."     by default, parcheck only compares parameter names\n"
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
#			exit 1;
		}
		shift @ARGV;
	}     # while options left on the command line
} else {
	
}

exit unless ( $#ARGV == 1 );


my $file1 = $ARGV[0];
$file1    = "$ENV{PWD}"."/$file1" unless ( $file1 =~ /^\// );
my $file2 = $ARGV[1];
$file2    = "$ENV{PWD}"."/$file2" unless ( $file2 =~ /^\// );

my ($root,$path,$suffix) = File::Basename::fileparse($file1,'\..*');

my $file = "file$suffix";

mkdir "temp.$$", 0755;
chdir "temp.$$";

mkdir "dir1", 0755;
chdir "dir1";
`ln -s $file1 $file`;
chdir "..";

mkdir "dir2", 0755;
chdir "dir2";
`ln -s $file2 $file`;
chdir "..";

print `isdc_dircmp dir1 dir2`;

chdir "..";
`rm -r temp.$$`;

exit;


# last line
