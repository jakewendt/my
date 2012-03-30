#!/usr/bin/perl -w


print "\$? is $?\n";

`echo Test`;

print "\$? is $?\n";

print `echo Test`;

print "\$? is $?\n";

`cat  Test`;

print "\$? is $?\n";

print `echo Test`;

print "\$? is $?\n";

my @results = `cat  Test`;

print "\$? is $?\n";

print `echo Test`;

print "\$? is $?\n";

