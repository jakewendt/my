#!/usr/bin/perl -w

use strict;

sub mycut{
	my $s = shift;
	my $l = shift;
	while ( length($s)>$l ) {
		$s =~ s/ \w+\.?$//;
	}
	return $s;
}

sub ticks{
	my $max = shift;
	my $num = shift || 5;
	for ( my $i = 1; $i <= $max; $i++ ) {
		my $t = ($i % $num) ? "." : $i;
		$t =~ s/^.*(\d{1})$/$1/;
		print $t;
	}
}

ticks(50);
print "\n";
print mycut("This is a sentence that is way too long.", 50)."x\n";
print mycut("This is a sentence that is way too long.", 45)."x\n";
print mycut("This is a sentence that is way too long.", 40)."x\n";
print mycut("This is a sentence that is way too long.", 35)."x\n";
print mycut("This is a sentence that is way too long.", 30)."x\n";
print mycut("This is a sentence that is way too long.", 25)."x\n";
print mycut("This is a sentence that is way too long.", 20)."x\n";
print mycut("This is a sentence that is way too long.", 15)."x\n";
print mycut("This is a sentence that is way too long.", 10)."x\n";

exit;
