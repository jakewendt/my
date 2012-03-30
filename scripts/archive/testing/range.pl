#!/usr/bin/perl -w

my @revs;

for ( my $i=0; $i<=$#ARGV; $i++ ) {
#	print "$ARGV[$i]\n";
	#if     last one      or    next one is ".."
	if ( ( $i == $#ARGV ) || ( $ARGV[$i+1] !~ /\.\./ ) ) {
		push @revs, $ARGV[$i];
	} else {
		push @revs, ( $ARGV[$i] .. $ARGV[$i+2] );
		$i+=2;
#		print "$ARGV[$i] .. $ARGV[$i+2]\n";
	}
}

#print "----\n";

foreach my $rev ( @revs ) {
	printf ( "%04d\n",$rev );
}

