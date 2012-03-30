#!/usr/bin/perl -w



if ( $ENV{GZIP} ) {
	print "1. test = $ENV{GZIP}\n";
}

	delete ( $ENV{GZIP} );

if ( $ENV{GZIP} ) {
	print "2. test = $ENV{GZIP}\n";
}

	delete ( $ENV{GZIP} );




exit;


