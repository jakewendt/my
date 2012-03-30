#!/usr/bin/perl -w

my %h = ( "a" => 1, "b" => 2, "c" => 3 );

#print %h;

my @arr = keys ( %h );

print "1: ".scalar ( keys ( %h ) )."\n";
print "2: ".keys ( %h )."\n";
print "3: ",keys ( %h ),"\n";

print "\n";


