#!/usr/bin/perl -w



	
	for ( $j=1; $j < 3; $j++ ) {
		my $low;
		my $high;

		print "low defined\n" if defined($low);		#	it shouldn't be

		for ( $i=0; $i < 10; $i++ ) {
			$low  = $i * $j if ( !defined ($low)  || ( ($i * $j) < $low  ) );
			$high = $i * $j if ( !defined ($high) || ( ($i * $j) > $high ) );
			print "$i : $j\n";
		}

		print "low  : $low\n"  if ( defined ($low) );
		print "high : $high\n" if ( defined ($high) );

		my $diff = $high - $low;
		print "diff = $diff\n";

		my $test = $high / 7;
		print "test = $test\n";
	}

	my $newdiff = 1.20010000000000E+01 - 1.09990000000000E+01;
	print "test = $newdiff\n";
	

exit;


