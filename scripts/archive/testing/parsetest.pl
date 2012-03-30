#!/usr/bin/perl -w


my $line = "Log_1  : Input Time(REVNUM): 54 Output Time(IJD): Boundary 1177.92177296296313215862 1180.91137944444449203729";



print "$line\n";


my @words = split ('\s+',$line);
print "$words[$#words-1]\n";
print "$words[$#words]\n";




exit;


