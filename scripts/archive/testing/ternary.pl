#!/usr/bin/perl -w



my $string = "My name is Jake.";

$string =~ /name is (\w+)./;
print "$1\n";

my $var = ( $1 eq "Jake" ) ? "Jake" : "not Jake";

print "$var\n" && exit if (0==1);

print "did not return\n";


exit;


