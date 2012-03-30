#!/usr/bin/perl -w

my @results;

$ENV{COMMONLOGFILE} = "+$ENV{HOME}/common_log.txt";

my $rootdir = "/isdc/arc/rev_2/scw/";
chdir "$rootdir";

foreach my $rev ( `ls -d1 0009` ) {
	chomp $rev;
#	print "rev = $rev\n";
	chdir "$rev";
	foreach my $scw ( `ls -d1 0*` ) {
		chomp $scw;
#		print "scw = $scw\n";
		chdir "$scw";
		print `ls $rootdir/$rev/$scw/ibis_deadtime*`;
		@results = `dal_list swg.fits+1 fulldols=n extname="*DEAD-SCP" | grep "Rows" | grep -vs "JMX"`;
#		@results = `dal_list swg.fits+1 fulldols=n extname="*DEAD-SCP" | grep "\\\-DEAD\\\-SCP" | grep -vs "JMX"`;
		if (@results) {
			print "	".join'	',@results;
		} else {
			print "	NOT Attached - ";
	      print `dal_list ibis_deadtime.fits+1 fulldols=n | grep Rows`;
		}


#		print `dal_list swg.fits+1 fulldols=n | grep DEAD`;
		chdir "..";
	}
	chdir "..";

}

exit;



#print `dal_list /isdc/arc/rev_2/scw/0070/007000730010.001/swg.fits+1 fulldols=n extname="*DEAD*" | grep "\\\-DEAD\\\-SCP"`;
#exit;

# isdc_int@isdcsf3 : unit_test 331> dal_list /isdc/arc/rev_2/scw/0070/007000720010.001/swg.fits+1 fulldols=n | grep DEAD
# isdc_int@isdcsf3 : unit_test 331> ll /isdc/arc/rev_2/scw/0070/007000720010.001/ibis_deadtime*
# -r--r--r--    1 archive  privatei    11116 Aug 29 19:35 /isdc/arc/rev_2/scw/0070/007000720010.001/ibis_deadtime.fits.gz


