#!/usr/bin/perl -w


my @arr;
$#arr=100;

print $#arr;
my $i =0;
foreach ( @arr ) {
	$_ = 0;
}

foreach ( @arr ) {
	print $_;
}


