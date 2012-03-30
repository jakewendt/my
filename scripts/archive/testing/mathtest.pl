#!/usr/bin/perl

use POSIX qw(ceil floor);
#      Math.round((pos % (1/pulses)) * pulses) == 0 ? 
#            ((pos * pulses * 2) - Math.floor(pos * pulses * 2)) : 
#        1 - ((pos * pulses * 2) - Math.floor(pos * pulses * 2))
#      );

my $pulses = 2;
for ( my $pos = 0.01; $pos < 1; $pos+=0.01 ) {
	my $out = ( int((( $pos % ceil( 1/$pulses )) * $pulses ) + 0.5 ) == 0) ?     
		     (($pos * $pulses * 2) - floor($pos * $pulses * 2)):
		 1 - (($pos * $pulses * 2) - floor($pos * $pulses * 2));
	printf( "%5.2f : %5.2f \n", $pos, $out );
}

