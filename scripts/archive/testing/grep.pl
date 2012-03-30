#!/usr/bin/perl -w

#	match this line

open INFILE, "< $0";
my @lines = grep "test", (<INFILE>);
close INFILE;

print @lines;


