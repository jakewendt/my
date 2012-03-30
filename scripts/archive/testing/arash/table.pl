#! /bin/sh
eval '  exec perl -x $0 ${1+"$@"} '
#! perl -w

#	Can't use -w and use strict when using -s
#	-w
use strict;

while (<>) {
	my @nums = split /\s+/, $_; 
	my $counter = $nums[$#nums];
	while ( $counter-- ) {
		print $_;
	}
}
