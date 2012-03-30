#!/usr/bin/perl -w


my $var = "test this";

print << "EOF";
This is a multiline here\n
document terminated by EOF
$var
on a line by itself
EOF

print "--------\n";

my @data = << "EOF";
This is a multiline here\n
document terminated by EOF
$var
on a line by itself
EOF

print "@data\n";



exit;



