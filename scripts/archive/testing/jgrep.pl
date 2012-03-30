#!/usr/bin/perl -w

my $i = 0;

while (<>) {
	$i++;
	print " $i : $_" if ( /[chwx]{3}/ );
}



