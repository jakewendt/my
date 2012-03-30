#!/usr/bin/perl -w

my $string = "/nrt/ops_1/obs/qsj2_041600430010.000:";

print "$string\n";

my ( $obs_id, $scw ) = ( $string =~ /(qs.._(\d{12}))/ );

print "$obs_id, $scw\n";

my ( $obs_path, $scw2 ) = ( $string =~ /^(.+(\d{12}).000)/ );

print "$obs_path, $scw2\n";

