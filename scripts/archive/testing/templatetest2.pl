#!/usr/bin/perl -w

use ISDCPipeline;

my @structs;

foreach ( `$ISDCPipeline::myls -1 $ENV{CFITSIO_INCLUDE_FILES}/*ALL.tpl` ) {
	chomp;
	s/(\.tpl)\s*$//;
	my @names = split ( "/" );
	push  @structs, $names[$#names];
}

foreach $struct ( @structs ) {
	foreach $level ( "RAW", "PRP", "COR" ) {
		my $temp = ${struct};
		$temp =~ s/(ALL)/${level}/;
		print "${temp}\n";
	}
}






exit;


