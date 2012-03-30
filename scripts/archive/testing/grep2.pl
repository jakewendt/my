#!/usr/bin/perl -w

my %seen = ();

foreach ( qw/1 2 3 4 5 1 2 3/ ) {
	print "$_ : ".!$seen{$_}++."\n";
}

#	!$seen{$_}++ is basically a "unique" function
