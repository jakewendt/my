#!/usr/bin/perl -s

#	use strict;	#	can't ( use strict and -w ) with -s

my %md5s;

while (<>) {
#	MD5 (The Simpsons - 17x07 - The Last of the Red Hat Mamas.avi) = c5acc3114b85370dab16f9014dc5bb1c
#	c5acc3114b85370dab16f9014dc5bb1c The Simpsons - 17x07 - The Last of the Red Hat Mamas.avi
	my ( $md5, $filename ) = /^([\w\d]+)\s+(.+)$/;
	print "md5: $md5 ; filename: $filename\n" if ( $debug );
	if ( exists ( $md5s{$md5} ) ) {
		printf ( "Found dupe :   %-70s %-70s\n", $md5s{$md5}, $filename );
	} else {
		print "New : $filename\n" if ( $debug );
		$md5s{$md5} = "$filename";
	}
}

exit;

#	last line
