#!/usr/bin/perl -w

my $line = "one two three four";
my @words = split ( " ", $line );
my $lastword = $words[$#words];

print "$line\n";
print "$lastword\n";


exit;


