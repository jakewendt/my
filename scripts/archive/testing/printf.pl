#!/usr/bin/perl -w

use strict;

my @revnos = ( "0410", "430", 1, 0 , 100, '030' ); 

foreach my $revno ( @revnos ) {
	my $line = sprintf ( "%s %d %04d \n", $revno, $revno, $revno );
	print $line;
}


