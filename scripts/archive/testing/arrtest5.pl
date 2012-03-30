#!/usr/bin/perl -w

my $jnum = 1;
my @zlist = ( "jmx${jnum}_gti.fits.gz", "jmx${jnum}_dead_time.fits.gz", "jmx${jnum}_full_cor.fits.gz" );


foreach ( @zlist ) {
	print "Z - $_\n";
}

print "\n";

$zlist[1] = "jmx${jnum}_deadtime.fits.gz";
foreach ( @zlist ) {
	print "Z - $_\n";
}

print "\n";

my @flist = @zlist;
foreach ( @flist ) {
	s/\.gz\s*$//;
}

foreach ( @flist ) {
	print "F - $_\n";
}

print "\n";

foreach ( @zlist ) {
	print "Z - $_\n";
}

print "\n";


#	print "Count is ".@zlist."\n";
#	print "Count is $#zlist\n";
#	print pop(@zlist)."\n";
#	print "Count is $#zlist\n";
#	print pop(@zlist)."\n";
#	print "Count is $#zlist\n";
#	print pop(@zlist)."\n";
#	print "Count is $#zlist\n";
#	print pop(@zlist)."\n";
#	print "Count is $#zlist\n";

print "Array is @zlist\n";
while ( @zlist ) {
	print pop(@zlist)."\n";
}



exit;


