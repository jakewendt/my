#!/usr/bin/perl -w

use strict;

#	this function was written to change the output format from one version of md5 to the standard md5sum format

while (<>) {
#	MD5 (The Simpsons - 17x07 - The Last of the Red Hat Mamas.avi) = c5acc3114b85370dab16f9014dc5bb1c
#	c5acc3114b85370dab16f9014dc5bb1c The Simpsons - 17x07 - The Last of the Red Hat Mamas.avi
	my ( $filename, $md5 ) = /^MD5 \((.*)\) = ([\w\d]+)$/;
	print "$md5  $filename\n";
}

exit;

#	last line
