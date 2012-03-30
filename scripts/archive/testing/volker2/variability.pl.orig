#! /bin/sh
eval '  exec perl -x $0 ${1+"$@"} '
#! perl -s

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
	my $i = 0;		#	this will be incremented before first usage so set to 0 and not 1
	my $sum1 = 0;
	my $sum2 = 0;
	
	while (<FILE>) {
		my ( $dummy1, $x_, $sigma_, $dummy2 ) = split /\s+/;
		next unless ( $dummy1 && $x_ && $sigma_ && $dummy2 );				#	tiny bit of error checking
		$i++;																				#	ASSUMING LEGITIMATE LINE !!!!
		$x[$i] = $x_;
		$sigma[$i] = $sigma_;
		$x_sum += $x[$i];
		$sum1 += $x[$i] / $sigma[$i] / $sigma[$i];
		$sum2 += 1 / $sigma[$i] / $sigma[$i];
		print "i:$i : x[i]:$x[$i] sigma[i]:$sigma[$i] x_sum:$x_sum sum1:$sum1 sum2:$sum2\n" if ( $debug );
	}
	my $ratesum = $sum1 / $sum2;						#	to be used at a later date
	my $rateerrorsum = sqrt (1 / $sum2);						#	to be used at a later date
	my $x_bar = $x_sum / $i;

	print "ratesum:$ratesum rateerrorsum:$rateerrorsum x_bar:$x_bar\n" if ( $debug );
	
	my $i0 = 1;
	my $iN = $i;
	my $sigma_Q       = 0.0;
	my $sigma_Q_delta = 0.0001;
	my $sigma_Q_max   = 1.0;
	my $delta_min     = 0.0000000000000001;	#	smallest value that doesn't cause any problems within perl
	
#	print LOG "plot '-' using 1:2\n" if ( ( $gnuplot ) && ( $debug ) );
	
	my $debug_value    = 999999999;
	my $best_sigma_Q   = $debug_value;
	my $best_summation = 100;
	my $best_estimator = $debug_value;
	while ( $sigma_Q_delta >= $delta_min ) {
		my $sign_change = 0;
		my $previous_sign = 0;

		while ( $sigma_Q < $sigma_Q_max ) {
			my $summation = 0;
			for ( my $i=$i0; $i<=$iN; $i++ ) {
				my $x_paren = ( $x[$i] - $x_bar ) ** 2;
				my $sigma_paren = ( ( $sigma[$i] ** 2 ) + ( $sigma_Q ** 2 ) );
				$summation += ( $x_paren - $sigma_paren ) / ( ( $sigma_paren ) ** 2 );
			}

			my $estimator = $sigma_Q / $ratesum * 100.0;		#	don't need to calculate for all sigma_Q so could put this somewhere else
			print "sigma_Q:$sigma_Q  summation:$summation estimator:$estimator\n" if ( $debug );
			if ( ( $summation > 0 ) && ( $summation < $best_summation ) ) {				#	searching for smallest positive summation
				$best_sigma_Q = $sigma_Q ;
				$best_estimator = $estimator;
			}
			$sign_change = $sigma_Q if ( ( $previous_sign > 0 ) && ( $summation < 0 ) && ( ! $sign_change ) );	#	searching for FIRST NEGATIVE summation
			$previous_sign = ( $summation > 0 ) ? +1 : -1;		#	If the initial summation is negative, this doesn't work.
			$sigma_Q += $sigma_Q_delta;
		}
#		die "NO SIGN CHANGE!  sigma_Q=0 probably generated a negative summation" unless ( $sign_change );
		last unless ( $sign_change );

		$sigma_Q     = $sign_change - $sigma_Q_delta;
		$sigma_Q     = 0 if ( $sigma_Q < 0 );				#	just in case the sign change was almost immediate which could cause $sigma_Q to be negative.
		$sigma_Q_max = $sign_change + $sigma_Q_delta;	#	include more than necessary to ensure a sign_change next loop
		$sigma_Q_delta /= 10;
	}
	
	close FILE;
	$best_sigma_Q   = "" if ( $best_sigma_Q == $debug_value );
	$best_estimator = "" if ( $best_estimator == $debug_value );
	printf ( "Best sigma_Q for %-86s : %15.10e : estimator : %15.8f\n", $file, $best_sigma_Q, $best_estimator );
}

#if ( $debug ) {
#	print LOG "e\n" if ( $gnuplot );
#	close LOG;
#}

