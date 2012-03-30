#!/usr/bin/perl -w -I /isdc/integration/isdc_int/sw/nrt_sw/prod/opus/pipeline_lib/

use ISDCPipeline;

my $localdir = "/mkdir-test";

`$ISDCPipeline::mymkdir -p ${localdir}`;
   die "*******     ERROR:  couldn't make dir ${localdir}.\n" if ($?);


exit;


