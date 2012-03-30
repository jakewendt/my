#!/usr/bin/perl -w


my $var = "xyz";

my $ptr = \$var;

print "var    = $var\n";
print "ptr    = $ptr\n";
print "ptrval = $$ptr\n";

exit;
