#!/usr/bin/perl -w


my @arr = ( "A", "B", "C", "", " " );

foreach ( @arr ) {
	print ":$_:\n" if ( $_ );
}


exit;
