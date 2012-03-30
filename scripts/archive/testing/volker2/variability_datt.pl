#! /bin/sh
eval '  exec perl -x $0 ${1+"$@"} '
#! perl -s

use VLIB;

#       Can't use -w and use strict when using -s
#       -w
#use strict;
#	
#the data are under
#	/unsaved_data/beckmann/SwiftXLF/BAT_light/only_AGN/dwell
#	
#	For the moment you can start with the files which have the extension
#	.datt7
#	(this means the data are binned to 7-day intervals)
#	
#	First column: Time (days) [not relevant for the variability test, but it might be worth checking whether the average bin time is really close to 7 days]
#	second column: count rate (x_i)
#	third    column: error of count rate (sigma_i)
#	fourth  column: significance (not relevant) 

foreach my $file ( @ARGV ) {
	open FILE, "< $file";
	my $x_sum = 0;
	my @x;
	my @sigma;
	my $i = 0;
	my $sum1 = 0;
	my $sum2 = 0;
	
	while (<FILE>) {
		my ( $dummy1, $x_, $sigma_, $dummy2 ) = split /\s+/;
		next unless ( $dummy1 && $x_ && $sigma_ && $dummy2 );				#	tiny bit of error checking
		$x[$i] = $x_;
		$sigma[$i] = $sigma_;
		$x_sum += $x[$i];
		$sum1 += $x[$i] / $sigma[$i] / $sigma[$i];
		$sum2 += 1 / $sigma[$i] / $sigma[$i];
		print "i:$i : x[i]:$x[$i] sigma[i]:$sigma[$i] x_sum:$x_sum sum1:$sum1 sum2:$sum2\n" if ( $debug );
		$i++;																			#	ASSUMING LEGITIMATE LINE !!!!
	}
	my $ratesum = $sum1 / $sum2;						#	to be used at a later date
	my $rateerrorsum = sqrt (1 / $sum2);						#	to be used at a later date
	my $x_bar = $x_sum / scalar(@x);
	print "ratesum: $ratesum  ;  rateerrorsum: $rateerrorsum  ;  x_bar: $x_bar \n" if ( $debug );

	my ( $best_sigma_Q, $best_estimator ) = VLIB::GetBest(
		'ratesum'	   => $ratesum,
		'rateerrorsum'	=> $rateerrorsum,
		'x_bar'	=> $x_bar,
		'x'	=> \@x,
		'sigma'	=> \@sigma,
	);
	close FILE;
	printf ( "Best sigma_Q for %-86s : %15.10e : estimator : %15.8f\n", $file, $best_sigma_Q, $best_estimator );
}
