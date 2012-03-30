#!/usr/bin/perl -w -I /isdc/integration/isdc_int/sw/nrt_sw/prod/opus/pipeline_lib/



my $files = `find . -name f\\\*`;
#my $files = `find . -name f\\\*`;
$files =~ s/\n/ /g;

print $files;


print `ls -l $files`;



exit;

