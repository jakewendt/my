#!/usr/local/bin/perl -w

use strict;
use File::Basename;

my $dryrun;
my $filelist = "";

my $FUNCNAME = "removedupes.pl";
my $FUNCVERSION = "1.0";

exit unless ( $#ARGV >= 0 );

#	print "$#ARGV\n";
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
					."  --dryrun           -> don't do anything\n"
					."\n\n"
				; # closing semi-colon
				exit 0;
			}
		elsif ( /-v/ ) {
			print "Log_1  : Version : $FUNCNAME $FUNCVERSION\n";
			exit 0;
		}
		elsif ( /-dry/) {
			$dryrun++;
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

my $target = "DUPES";

#	loop through all the rest after the first without a leading -
while ( $ARGV[0] ) {
	$filelist = $ARGV[0];
	#print "$filelist\n\n";

	open INFILE, $filelist;
	my $filename;
	while (<INFILE>) {
		( $filename ) = ( /^.{32}  (.*)$/ );
		#print "$filename\n";
		my $dir = dirname  ( $filename );
		my $fnm = basename ( $filename );
		#print "$dir - $fnm\n";

		if ( -e "$target/$filename" ) {
			print "\n$target/$filename ALREADY EXISTS!!!\n";
			print "$filename DOES NOT EXIST EITHER!!!\n" unless ( -e "$filename" );;
			print "\n";
			next;
		}
		unless ( -e "$filename" ) {
			print "\n$filename DOES NOT EXIST!!!\n\n";
			next;
		}

		system ( "mkdir -p \"$target/$dir\"" )unless ( -d "$target/$dir" );
		if ( -d "$target/$dir" ) {
			print "     mv $filename $target/$dir\n";
			system ( "mv \"$filename\" \"$target/$dir/\"\n" );
		} else {
			print "\nTARGET DIR $target/$dir DOES NOT EXIST\n\n";
		}
	}

	close INFILE;
	shift @ARGV;
}     # while options left on the command line

exit;




