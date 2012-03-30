#!/usr/bin/perl -w
#
#
#	040301 - Jake
#
#	This script was used to compare the data structure
#	before and after reprocessing modifications
#	of Preproc and the pipeline scripts.
#
#	(Or any other time for that matter.)
#
#	Example of usage:
#	
#		mkdir before
#		mkdir after
#		mkdir -p out/aux/adp
#		cd out/aux/adp
#		ln /isdc/arc/rev_1/aux/adp/0024.001			(0024.000 for nrt)
#		ln /isdc/arc/rev_1/aux/adp/0025.001			(0025.000 for nrt)
#		cd ../../../
#		chmod 755 outref
#		mkdir -p outref/aux/adp
#		cd outref/aux/adp
#		ln /isdc/arc/rev_1/aux/adp/0024.001			(0024.000 for nrt)
#		ln /isdc/arc/rev_1/aux/adp/0025.001			(0025.000 for nrt)
#		cd ../../../
#		compareoutoutref2.pl
#		diff -r before after
#
#		cat before/* after/* | grep -vs Log_1
#

use strict;

my $filename = "";
my $FUNCNAME = "compareoutoutref";
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
}
#exit unless ( $#ARGV >= 0 );

my %file;

my @out = `find out\*  -name swg\*.fits\*`;
my @dircomps = ();

# out/scw/0025/002500000041.000/swg.fits
foreach ( @out ) {
	chomp;
	@dircomps = split /\//, $_;

	$file { $dircomps[3] } { "revno" }    = $dircomps[2];
	if ( ( $dircomps[0] =~ /^outref/ ) && ( $dircomps[4] =~ /swg_raw.fits/ ) ) {							#	there's gotta be a better way
		$file{$dircomps[3]}{"outrefraw"} = $_;
	} elsif  ( ( $dircomps[0] =~ /^outref/ ) && ( $dircomps[4] =~ /swg_osm.fits/ ) ) {
		$file{$dircomps[3]}{"outrefosm"} = $_;
   } elsif  ( ( $dircomps[0] =~ /^outref/ ) && ( $dircomps[4] =~ /swg_prp.fits/ ) ) {
		$file{$dircomps[3]}{"outrefprp"} = $_;
   } elsif  ( ( $dircomps[0] =~ /^outref/ ) && ( $dircomps[4] =~ /swg.fits/ ) ) {
		$file{$dircomps[3]}{"outrefswg"} = $_;
   } elsif  ( ( $dircomps[0] =~ /^out/ ) && ( $dircomps[4] =~ /swg_raw.fits/ ) ) {
		$file{$dircomps[3]}{"outraw"} = $_;
   } elsif  ( ( $dircomps[0] =~ /^out/ ) && ( $dircomps[4] =~ /swg.fits/ ) ) {
		$file{$dircomps[3]}{"outosm"} = $_;
	} else {
		print "ERROR\n";
		print "$_\n";
		print "$dircomps[4]\n";
		print "ERROR\n";
	}
}


foreach ( keys %file ) {			#	scwid
	chomp;
	print $file{$_}{"outrefraw"}." and ".$file{$_}{"outraw"}."\n";
	`dal_list $file{$_}{"outrefraw"}\+1 | sort > before/$_.raw`;
	`dal_list $file{$_}{"outraw"}\+1 | sort > after/$_.raw`;
	`dal_list $file{$_}{"outosm"}\+1 | sort > after/$_.osm`;
	if ( defined ( $file{$_}{"outrefosm"} ) ) {
		print $file{$_}{"outrefosm"}." and ".$file{$_}{"outosm"}."\n";
		`dal_list $file{$_}{"outrefosm"}\+1 | sort > before/$_.osm`;
	} elsif ( defined ( $file{$_}{"outrefprp"} ) ) {
		print $file{$_}{"outrefprp"}." and ".$file{$_}{"outosm"}."\n";
		`dal_list $file{$_}{"outrefprp"}\+1 | sort > before/$_.osm`;
	} elsif ( defined ( $file{$_}{"outrefswg"} ) ) {
		print $file{$_}{"outrefswg"}." and ".$file{$_}{"outosm"}."\n";
		`dal_list $file{$_}{"outrefswg"}\+1 | sort > before/$_.osm`;
	} else {
		print "ERROR\n";
	}


}












exit;



