#!/usr/bin/perl 

#	http://www.ecmselection.co.uk/high_iq_enter_and_win/

#
#	brainbuster no. 22 - Out for the count
#
#	This competition closed on 2 April 2007.
#	the brainbuster
#	
#	The sum of all the digits used in the series of numbers from 1 to 12 inclusive is 51:
#	
#	i.e. 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + (1 + 0) + (1 + 1) + (1 + 2) = 51
#	
#	The sum of all the digits used in the series of numbers from 1,020 to 1,022 inclusive is 12:
#	
#	i.e. (1 + 0 + 2 + 0) + (1 + 0 + 2+ 1) + (1 + 0 + 2 + 2) = 12
#	
#	What is the sum of all the digits used in the numbers from 1 to 1,000,000 inclusive?
#	
#	(In addition to providing the correct answer, you must also show the method that you used to calculate the sum.)
#	the solution
#	
#	Answer: 27,000,001
#	
#	The solution as provided by our winner:
#	
#	Leave 1,000,000 on its own, then pair up the numbers as follows:
#	
#	(999,999) with (0)
#	(999,998) with (1)
#	
#	And so on until:
#	
#	(500,000)+(499,999)
#	
#	so all the numbers from 1 to 999,999 appear in a pair. The digits in each pair add up to 54, and there are 500,000 pairs, giving a total of 27,000,000. Then add in the (1) from (1,000,000) to give 27,000,001.
#	and the lucky winner is...
#	
#	Congratulations to Peter Wilkins - currently studying for a PhD in Aerodynamics at Cranfield University - who wins £200 of Firebox vouchers.
#	



my $sum = 0;

foreach my $num ( $ARGV[0] .. $ARGV[1] ) {
	foreach ( 1 .. length($num) ) {
		$sum += chop $num;
	}
}

print "$sum\n";

exit;

__END__


for ( my $i=0; $i<=$#digits; $i++ ) {
	my $s = sprintf ( $digits[$i] );
	for( my $i = length($s); $i>0; $i-- ) {
		$sum += chop $s;
	}
}


__END__


for ( my $i=0; $i<=$#digits; $i++ ) {
	$s .= sprintf ( $digits[$i] );
}

for( my $i = length($s); $i>0; $i-- ) {
#	my $ch = chop $s;
#	print "$ch\n";
#	$sum += $ch;
	$sum += chop $s;
}

print "$sum\n";
