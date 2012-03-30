#!/usr/bin/perl -w

use strict;

print "$ARGV[0]\n";
#my $first = `find $ARGV[0] -type f | head -1`;
my $first = $ARGV[0];
print "$first\n";
chomp $first;

my @filestats = stat ( $first );
#my @filestats = stat ( `find $ARGV[0] -type f | head -1` );

print "@filestats\n";

if ( $filestats[4] =~ /4948/ ) {
	print "Owned by isdc_int\n";
} else {
	print "I don't know who owns this\n";
}
	


exit;


