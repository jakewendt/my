#!/usr/bin/perl -w

use ISDCPipeline;

my $scwdir = "/isdc/integration/isdc_int/sw/dev/prod/opus/nrtscw/unit_test/outref/scw/";
my $cwd = `pwd`;
   print "\n\nJAKE - pwd  : $cwd\n\n";

#print `/bin/ls -1`;
#chdir $scwdir;
#print `/bin/ls -1`;

#foreach $revol ( `/bin/ls -1` ) {
#	chomp $revol;
#	print "${revol}";
#	print "${scwdir}${revol}";
#	chdir "${scwdir}${revol}";
#	chdir "${revol}";
#	foreach $scwid ( `/bin/ls -d1 $scwdir/0024/*` ) {
	foreach $scwid ( `$ISDCPipeline::myls -d $scwdir/0024/*` ) {
#		chomp $scwid;
		next unless ( $scwid =~ /\d{12}\.\d{3}/ );
		print "$scwid";
#		print "+${scwid}";
#		chdir "${scwid}";
	#	print `pwd`;
#		chdir "..";
#	}
}
exit;


