#!/usr/bin/perl 

use strict;

#	http://www.ecmselection.co.uk/high_iq_enter_and_win/
#
#brainbuster no. 25 - Remove Digits
#
#This competition closes on Sunday 30 March 2008.
#the brainbuster
#
#    "Using each of the numbers 1, 2, 3, 4, 5, 6, 7, 8, 9 only once, 
#     form a nine digit number A that can satisfy the following criteria:
#
#    - A is exactly divisible by 9.
#
#    - Removing the rightmost digit from A forms an eight digit number B that is exactly divisible by 8.
#
#    - Removing the rightmost digit from B forms a seven digit number C that is exactly divisible by 7.
#
#    - Removing the rightmost digit from C forms a six digit number D that is exactly divisible by 6.
#
#    - Removing the rightmost digit from D forms a five digit number E that is exactly divisible by 5.
#
#    - Removing the rightmost digit from E forms a four digit number F that is exactly divisible by 4.
#
#    - Removing the rightmost digit from F forms a three digit number G that is exactly divisible by 3.
#
#    - Removing the rightmost digit from G forms a two digit number H that is exactly divisible by 2.
#
#    What is A?
#
#    Show how you produced B, C, D, E, F, G & H."
#

mysub ( "", (1..9) );

sub mysub {
	my ( $num, @digitsleft ) = @_;
	foreach ( 1..scalar(@digitsleft) ) {
		my @digitsleft = @digitsleft;
		my $newnum = "$num".splice( @digitsleft, $_-1, 1 );
		next if ( $newnum % (9-scalar(@digitsleft)) );
		print "$newnum is divisible by ",9-scalar(@digitsleft),"\n";
		if (scalar(@digitsleft) > 1) {
			mysub ( $newnum, @digitsleft );
		} else {
			my $newnum = "$newnum".pop(@digitsleft);
			#	all of these 9 digit numbers are divisible by 9
			print "$newnum is divisible by ",9-scalar(@digitsleft),"\n";
		}
	}
}

exit;
