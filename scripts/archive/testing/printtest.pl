#!/usr/bin/perl -w

my $revno="0024";
my $num="1";
my $instr="JMX1";

print "$ENV{REP_BASE_PROD}/scw/${revno}/rev.000/idx/jemx".${num}."_aca_frss_index.fits[".${instr}."-GAIN-CAL-IDX,1]\n";

my $str = "Test THIS out.\n";

open OUT, ">> testfile";

print OUT $str;
print OUT uc($str);
print OUT lc($str);

#	print OUT "Below is an ll\n";
#	print OUT `/bin/ls /isdc 2>&1`;
#	print OUT "Above is an ll\n";

#	print OUT "Below is a df /isdc/run/pipelines/cons/*/input/\n";
#	print OUT `/bin/df -k /isdc/run/pipelines/cons/\*/input/ 2>1`;
#	print OUT "Above is a df\n";

close OUT;

print `echo ${instr}\[0]`;


exit;


