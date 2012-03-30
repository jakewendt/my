#!/usr/bin/perl

use lib "/unsaved_data/wendt/rsync/my/lib/";
use XML::Dumper;
use Data::Dumper;

my $hshref = xml2pl("test.xml");

print Dumper( $hshref );

#	foreach my $a ( keys ( %$hshref ) ) {
#		print "$a : $hshref->{$a}\n";
#		foreach my $b ( keys ( %{$hshref->{$a}} ) ) {
#			print "$b : $hshref->{$a}->{$b}\n";
#			foreach my $c ( keys ( %{$hshref->{$a}->{$b}} ) ) {
#				print "$c : $hshref->{$a}->{$b}-{$c}\n";
#			}
#		}
#	}
#	
#	print "\n\n$hsh{A}{name}\n";
