#!/usr/bin/perl -w

use IO::File;

my $path = "sysopen.test";

sysopen(FH, $path, O_WRONLY|O_TRUNC|O_CREAT, 0777) or die $!;
close FH;
