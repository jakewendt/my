#!/usr/bin/perl 

#	http://www.ecmselection.co.uk/high_iq_enter_and_win/
#
#	brainbuster no. 23 - Bright Idea
#	
#	This competition closes on Sunday 1 July 2007.
#	the brainbuster
#	
#	This puzzle involves turning a row of light bulbs on and off.
#	
#	In front of me are arranged one hundred light bulbs in a line, 
#	each with a switch underneath it, 
#	which changes the status of the bulb from OFF to ON, or from ON to OFF. 
#	The bulbs are numbered sequentially from 1 to 100 along the line. 
#	At the start all the light bulbs are OFF.
#	
#	Starting at the first light bulb I walk along the line flicking every switch. 
#	When I reach the end all the bulbs are ON. 
#	Without flicking any more switches I return to the start of the line and walk along for a second time, 
#	but this time I flick only every second switch (no?s 2, 4, 6, 8, 10, ... 96, 98, 100).
#	
#	It follows that when I reach the end of the line a second time all the odd numbered bulbs are ON, 
#	but all the even numbered bulbs have been turned back OFF. 
#	Once again, without flicking any more switches I return to the start of the line and carry on 
#	repeating the process of walking along the line flicking switches, but:
#	
#	The third time I walk along the line I flick only every third switch.
#	The fourth time I walk along the line I flick only every fourth switch.
#	The fifth time I walk along the line I flick only every fifth switch.
#	
#	And so on until I have walked along the line a hundred times, and on the one-hundredth time I flick only the one-hundredth switch.
#	
#	When I have finished are any of the light bulbs ON? If so, which numbers?
#	

my @lights;
for ( my $i=1; $i<=100; $i++ ) { $lights[$i] = 0; }

print "Initially all off ";
for ( my $i=1; $i<=100; $i++ ) {
	print "$lights[$i]";
}
print "\n";

for ( my $w=1; $w<=100; $w++ ) {				#	walk the lights 100 times
	for ( my $l=1; $l<=100; $l++ ) {			#	check all 100 lights
		unless ( $l % $w  ) {
			$lights[$l] = abs($lights[$l]-1);
		}
	}

	printf ("After pass: %03d   ", $w );
	for ( my $l=1; $l<=100; $l++ ) {
		print "$lights[$l]";
	}
	print "\n";
}

print "Which are on?\n";
for ( my $l=1; $l<=100; $l++ ) {
	print "$l, " if ( $lights[$l] ) ;
}
print "\n";

exit;

__END__

Here is the answer as provided by our winner:

The following lights are on:

1 4 9 16 25 36 49 64 81 100

Proof:

Each time we go down the row of switches, pressing every Nth switch (N=1..100), we do so for a switch M if N is one of the factors of M (including 1 and M).

Each switch starts in the off state, so if it is pressed an odd number of times, it will be on at the end. Therefore if M has an odd number of factors, then switch M will be left on at the end.

The only numbers with an odd number of factors are the square numbers. This can be seen as follows:

For all non-square numbers, the factors can be arranged into pairs, eg:

24 = 1 x 24 = 2 x 12 = 3 x 8 = 4 x 6 (ie 8 factors)

whereas for square numbers only, we have a "pair" of identical factors (ie one fewer factor), eg:

36 = 1 x 36 = 2 x 18 = 3 x 12 = 4 x 9 = 6 x 6 (ie 9 unique factors).
and the lucky winner is...

Congratulations to Ian Collinson, a Senior Programmer - and one of ecm's former placed candidates - who wins £200 of Firebox vouchers.


