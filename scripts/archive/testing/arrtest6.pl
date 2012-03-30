#!/usr/bin/perl -w

my @arr;

push @arr, "1";
push @arr, &testthis( "2" );
push @arr, &testthis();
push @arr, "4";

foreach ( @arr ) {
	print "$_\n";
}


exit;

sub testthis {
	return @_;
}


