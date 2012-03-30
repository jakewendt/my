#!/usr/bin/perl -w


#	testing for SPR 3762

foreach my $num ( 1, 2) {

	print "num = $num \n";
	my $off = abs ( $num - 2 ) + 1;
	print "off = $off \n";

}



exit;


