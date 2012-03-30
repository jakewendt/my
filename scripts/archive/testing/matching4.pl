#!/usr/bin/perl -w

my $string = " A B ";

print "$string\n";

my ( $str1, $str2, $str3 ) = ( $string =~ /(\d+) (\w*) (\w*)/ );

print "$str1, $str2, $str3\n" if ( $str1 && $str2 && $str3 );


