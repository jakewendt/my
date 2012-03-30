#!/usr/bin/perl -w

use strict;
use File::Basename;

my $dir0 = $ARGV[0];
my $dir1 = $ARGV[1];
my %md5s;

print "Comparing alerts in $dir0 to $dir1\n\n";

my $fl = length ( $dir0 ) + 33;

foreach my $dir ( $dir0, $dir1 ) {
	foreach my $alert ( glob("$dir/*alert") ) {
		my $md5 = &GetMD5 ( $alert );
		$md5s{$md5}{$dir} = $alert;
	}
}

foreach my $md5 ( keys ( %md5s ) ) {
	if ( exists $md5s{$md5}{$dir0} && exists $md5s{$md5}{$dir1} ) {
		printf ( "%${fl}s  :  %${fl}s\n", $md5s{$md5}{$dir0}, $md5s{$md5}{$dir1} );
	} elsif ( exists $md5s{$md5}{$dir0} ) {
		printf ( "%${fl}s  :  %${fl}s\n", $md5s{$md5}{$dir0}, "--- NO MATCH ---" );
	} elsif ( exists $md5s{$md5}{$dir1} ) {
		printf ( "%${fl}s  :  %${fl}s\n", "--- NO MATCH ---", $md5s{$md5}{$dir1} );
	} else {
		print "ERROR : Stray md5 found in my hash : $md5\n"; 
	}
}

exit;


#####################################################

sub GetMD5 {
	my $infile = $_[0];
#	print $infile;
	open ALERT, "< $infile";
	open TMP, "> .tmp_compare_alert";
	while (<ALERT>) {
		next if ( /Directory/ );
		next if ( /Alert generation time/ );
		next if ( /Task/ );
		
		#	2002-11-18T02:56:04
		#s/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}//g;

		#	/unsaved_data/isdc_int/opus_unit_tests/SunOS/adp/opus_work/adp/scratch/TSF_0011_0002_INT
		#s/\w+\///g;

		#	Task            : convertprogram 3.0
		#s/(^\s*Task\s*:\s*)\w+\s*[\d\.]+/$1/;
		print TMP "$_";
#		print "$_";
	}
	close ALERT;
	close TMP;
	chomp ( my $md5 = `cat .tmp_compare_alert | gmd5sum` );
	unlink ".tmp_compare_alert";
	return $md5;
}


#	last line
