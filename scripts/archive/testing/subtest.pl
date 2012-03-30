#!/usr/bin/perl -w


my $string = "somefilename.fits.gz";

print "Before: $string\n";
$string =~ s/\.gz$//;
print "After : $string\n";



exit;


