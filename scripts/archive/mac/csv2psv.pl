#!/usr/bin/perl -w

use strict;

my @strs;

while (<>) {
	next unless (/^\s*\w/);
	@strs = ParParse($_);

	for (my $i = 0; $i < $#strs-1; $i++) {
		print "$strs[$i]" if (defined ($strs[$i]));
		print "|";
	}
	print "\n";
}

exit;
  
  
#  This is straight out of the Perl cookbook, pg 31, sect 1.15:
sub ParParse {
	my $text = shift;
	my @new = ();
	push(@new,$+) while $text =~ m{
		"([^\"\\]*(?:\\.[^\"\\]*)*)",?
		|  ([^,]+),?
		| ,
		}gx;
	push(@new,undef) if substr($text, -1,1) eq ',';
	return @new;
}


