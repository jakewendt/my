#! /bin/sh
eval '  exec perl -x $0 ${1+"$@"} '
#! perl -s


my @lines = `fdump infile=/unsaved_data/beckmann/SwiftXLF/BAT_light/only_AGN/dwell/XXXJ2215.9+6106_dwell.fits outfile=STDOUT columns=THETA rows=- prhead=no pagewidth=256 page=no wrap=yes showrow=no showunit=no showscale=no showcol=n`;

shift @lines until $lines[0] !~ /^\s*$/;

foreach my $line ( @lines ) {
	print "a: $line";
}

close FILE;
