
package VLIB;


sub GetBest {
	&Carp::croak ( "Need even number of args" ) if ( @_ % 2 );

	my %att = @_;
	my $ratesum = $att{'ratesum'};
	my $rateerrorsum = $att{'rateerrorsum'};
	my $x_bar = $att{'x_bar'};
	my $file = $att{'file'};
	my $debug = $att{'debug'};
	my @x = @{$att{'x'}};
	my @sigma = @{$att{'sigma'}};


	print "ratesum:$ratesum rateerrorsum:$rateerrorsum x_bar:$x_bar\n" if ( $debug );
	
	my $i0 = 0;		#1;
	my $iN = $#x;	#$i;
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
	
	$best_sigma_Q   = "" if ( $best_sigma_Q == $debug_value );
	$best_estimator = "" if ( $best_estimator == $debug_value );

	return $best_sigma_Q, $best_estimator;
}

return 1;
