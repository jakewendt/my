#!/usr/bin/perl -w

use strict;

use lib "/isdc/integration/isdc_int/sw/dev/prod/opus/pipeline_lib/";
use ISDCLIB;

my ( $dirvers ) = ( &ISDCLIB::FindDirVers ( "$ENV{REP_BASE_PROD}/scw/0300/030000830010" ) =~ /\.(\d{3})$/ );

print "$dirvers\n";


