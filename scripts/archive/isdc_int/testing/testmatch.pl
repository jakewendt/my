#!/usr/bin/perl -w


my @data = qw/ garbage swg.fits swg_raw.fits swg_prp.fits swg_osm.fits morejunk.fits /;

print @data;
print "\n\n";

foreach ( @data ) {
	print $_;
	if ( /swg(_raw|).fits/ ) { 
		print "    good";
	}
	print "\n"
}


exit;



