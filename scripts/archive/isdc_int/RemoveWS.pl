#! /bin/sh
eval '  exec perl -x $0 ${1+"$@"} '
#! perl -w

use strict;
#use File::Basename;
#use ISDCPipeline;

while (<>) {
	s/^\s+//;
	print $_;
}

exit 0;

