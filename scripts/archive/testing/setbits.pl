#!/usr/bin/perl -w

use strict;

foreach (0..32) {
	print "$_:".func($_)."\n";
}

exit;

sub func {
	my $n = $_[0];
	my $b = 0;
	my $binary = "";
	while( $n >= 1 ) {
		$b++ if ( $n%2 );
#		if ( $n%2 ) {
#			$binary = "1".$binary;
#		}else{
#			$binary = "0".$binary;
#		}
		$n /= 2;
	}
#	print $binary,":";
	return $b;
}
