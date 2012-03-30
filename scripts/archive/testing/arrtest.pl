#!/usr/bin/perl -w

my @vars = ( 
	"a", "b", "c",
	"d d","e e", "f f",
	);

for ( my $i = 0; $i <= $#vars-2; $i+=3){
	print "$vars[$i]\n";
	print "$vars[$i+1]\n";
	print "$vars[$i+2]\n";
	print "\n";
}

exit;


