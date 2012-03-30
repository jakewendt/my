#!/usr/bin/perl 


#	http://www.ecmselection.co.uk/high_iq_enter_and_win/
#
#	brainbuster no. 24 - Guided Bus
#	
#	This competition closes on Sunday 25 November 2007.
#	the brainbuster
#	
#	"The Melchester Guided Bus system has become increasingly popular following the introduction 
#	of a controversial congestion charge scheme.
#	
#	The local council has therefore decided to add further stations on the guided bus route.
#	
#	Every station on the guided bus route sells tickets to every other station.
#	
#	When more stations are added, 46 sets of additional tickets will be required.
#	
#	How many stations will be added to the guided bus system - and how many stations are there at present?"
#	
#the solution
#
#Here is the answer as provided by our winner:
#
#There are currently 11 stations and 2 stations are to be added.
#
#The working:
#
#In a system as described containing N stations, the number of different single tickets is:
#
#(Eqn 1): N(N-1) = N^2 - N
#
#If M stations are added then the new number of tickets will be:
#
#(Eqn 2): (N+M)(N+M-1) = N^2 + NM - N + MN + M^2 - M
#
#The difference will therefore be:
#
#(Eqn 2) - (Eqn 1) = M^2 + M(2N-1)
#
#Which we are told is equal to 46 giving us
#
#(Eqn 3): M^2 + (2N-1)M -46 = 0
#
#Using the quadratic formula, to solve for M, the discriminant is (2N-1)^2 + 184.
#
#We know from the problem that M and N must be positive integers, 
#so the discriminant must be a perfect square.
#
#From the fact that the discriminant must be positive, we can deduce that N must be greater than 6.
#
#Substituting N=7 into (Eqn 3) and solving gives M = 2.89.
#
#This is an upper bound on M as can be seen by examination of (Eqn 3). 
#This suggests two possible solutions for M: 1,2.
#
#Substituting M = 2 into (Eqn 3) gives N = 11. Substituting M = 1 into (Eqn 3) gives N = 23.
#
#The problem does state that "stations" (plural) are added, so the actual solution is that there 
#are currently 11 stations and 2 stations are to be added.
#

#	What exactly is a "set" of additional tickets?  A-B and B-A or just A-B?

die "arg needs to be more than 3" if ( $ARGV[0] <= 2 );
my $sets = 0;
foreach my $stations ( 2 .. $ARGV[0] ) {
	my $newsets = $stations - 1;
	$sets += $newsets;
	printf ( "%3d %3d %3d \n", $stations, $sets, $newsets);
}


