#!/usr/bin/perl -s

#	use strict;	#	can't ( use strict and -w ) with -s

my @files;

do {
	push @files, glob ( shift ( @ARGV ) );
} while ( @ARGV );

foreach ( @files ) {
	print "Checking $_\n";
	if ( ( ! -e $_ ) && ( -l $_ ) ) {
		print "\t$_ is a (dead) link.  Deleting.\n";
		unlink $_ unless ( $dryrun || $dry || $dry_run );
	}
}

exit;

#	last line
