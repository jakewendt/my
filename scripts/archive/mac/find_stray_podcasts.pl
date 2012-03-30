#!/usr/bin/perl

#my @xml;

open XML, "< $ENV{HOME}/Music/iTunes/iTunes Music Library.xml" or die "Couldn't open xml";
while (<XML>) {
	next unless /Location/;
	next unless /Podcasts/;
	chomp;
	s/.+localhost//;
	s/<\/string>//;
	s/%20/ /g;
	s/%23/#/g;
	s/%25/%/g;
	s/%5B/[/g;
	s/%5D/]/g;
	s/%3B/;/g;
	s/#38;//g;
	s/%E2%80%B2/′/g;	#	this was for "macTV Show #7 - Apple _1984%E2%80%B2 Ad.mp4" and the ?~@? looked a bit like an apostrophe
	$xml{"$_"}++;
}
close XML;
#@xml = sort @xml;
#print @xml;

my @find = `find "$ENV{HOME}/Music/iTunes/iTunes\ Music/Podcasts" -type f`;
@find = sort @find;
#print @find;

foreach ( @find ) {
	chomp;
	next if /.DS_Store/;
	if ( exists $xml{"$_"} ) {
		delete ( $xml{"$_"} );
	} else {
		print "unique file  : $_\n";
	}
}

foreach ( sort keys %xml ) {
	print "unique entry : $_\n";
}


