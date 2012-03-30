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

my ( $m,$n,$o,$p,$q,$r,$s,$t,$u );
my @digits = (1..9);
foreach ( 1..9 ) {
	my @digitsleft = @digits;
	$m = splice @digitsleft, $_-1, 1;
#	print "$m\n";
	foreach ( 1..8 ) {
		my @digitsleft = @digitsleft;
		$n = splice @digitsleft, $_-1, 1;
		next if ( "$m$n" % 2 );
		print "$m$n is divisible by 2\n";
		foreach ( 1..7 ) {
			my @digitsleft = @digitsleft;
			$o = splice @digitsleft, $_-1, 1;
			next if ( "$m$n$o" % 3 );
			print "$m$n$o is divisible by 3\n";
			foreach ( 1..6 ) {
				my @digitsleft = @digitsleft;
				$p = splice @digitsleft, $_-1, 1;
				next if ( "$m$n$o$p" % 4 );
				print "$m$n$o$p is divisible by 4\n";
				foreach ( 1..5 ) {
					my @digitsleft = @digitsleft;
					$q = splice @digitsleft, $_-1, 1;
					next if ( "$m$n$o$p$q" % 5 );
					print "$m$n$o$p$q is divisible by 5\n";
					foreach ( 1..4 ) {
						my @digitsleft = @digitsleft;
						$r = splice @digitsleft, $_-1, 1;
					next if ( "$m$n$o$p$q$r" % 6 );
						print "$m$n$o$p$q$r is divisible by 6\n";
						foreach ( 1..3 ) {
							my @digitsleft = @digitsleft;
							$s = splice @digitsleft, $_-1, 1;
					next if ( "$m$n$o$p$q$r$s" % 7 );
							print "$m$n$o$p$q$r$s is divisible by 7\n";
							foreach ( 1..2 ) {
								my @digitsleft = @digitsleft;
								$t = splice @digitsleft, $_-1, 1;
					next if ( "$m$n$o$p$q$r$s$t" % 8 );
								print "$m$n$o$p$q$r$s$t is divisible by 8\n";
								foreach ( 1..1 ) {
									$u = @digitsleft[0];
#					next if ( "$m$n$o$p$q$r$s$t$u" % 9 );
									print "$m$n$o$p$q$r$s$t$u is divisible by 9\n";
								}
							}
						}
					}
				}
			}
		}
	}
}

sub mysub {
	my ( $num, @digitsleft ) = @_;
	foreach ( 1..scalar(@digitsleft) ) {
		my @digitsleft = @digitsleft;
		$digit = splice @digitsleft, $_-1, 1;
		next if ( "$num$digit" %  );
		print "$num$digit is divisible by 8\n";
		mysub ( $num-1, @digitsleft );
	}
}


exit;
