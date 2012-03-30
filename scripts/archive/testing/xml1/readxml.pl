#!/usr/bin/perl

use lib "/unsaved_data/wendt/rsync/my/lib/";
use XML::Simple;

#my %hsh = %{ XMLin("test.xml") };
my $hshref = XMLin("test.xml");
#my $hshref = XMLin("test.xml", ForceArray=>1);
#my %hsh = %$hshref;

foreach my $a ( keys ( %$hshref ) ) {
	print "$a :\n";
	foreach my $b ( keys ( %{$hshref->{$a}} ) ) {
		print "$b : $hshref->{$a}->{$b}\n";
#		foreach my $c ( keys ( %{$hshref->{$a}{$b}} ) ) {
#			print "$c : $hshref->{$a}{$b}{$c}\n";
#		}
	}
}

print "\n\n$hsh{A}{name}\n";
