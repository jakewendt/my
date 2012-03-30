#!/usr/bin/perl -w


my %use_hash;

foreach ( "AON", "AOFF", "ME" ) {
	${use_hash{${_}}} = "FALSE";
}

foreach ( "AON", "AOFF", "ME" ) {
	print "$use_hash{${_}}\n";			#	OK
#	print "${use_hash}{${_}}\n";		#	this line is incorrect 
	print "${use_hash{${_}}}\n";		#	OK
}








exit;


