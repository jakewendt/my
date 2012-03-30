#!/isdc/refsoftware/bin/perl -w

use strict;

$| = 1;


my $entries = 0;
my $total   = 0;
my %xfers;

open OUTFILE, "stats.041203";
while (<OUTFILE>) {
#                              pulsar.nsstc.nasa.gov   Jul      59.846 MB
	my ( $comp, $mth, $size ) = ( /\s+([\w\d\.\-]+)\s+(\w{3})\s+([\w\d\.\-]+) MB/ );

	$total += $size;
#	printf " Current %20.6f MB | Total %20d MB\r", $size, $total;
	$xfers{$comp}{$mth} += $size;
}
close OUTFILE;

print "\n";

my @tbl;
my %months;
$months{Jan} = 1;
$months{Feb} = 2;
$months{Mar} = 3;
$months{Apr} = 4;
$months{May} = 5;
$months{Jun} = 6;
$months{Jul} = 7;
$months{Aug} = 8;
$months{Sep} = 9;
$months{Oct} = 10;
$months{Nov} = 11;
$months{Dec} = 12;
my $idx = 0;
my %ctotals;
my %mtotals;

foreach my $comp ( keys(%xfers) ) {
	foreach my $month ( keys(%{$xfers{$comp}}) ) {
		#	printf " %40s   %3s  %12.3f MB\n", $comp, $month, $xfers{$comp}{$month};
		$tbl[$idx][0] = $comp;
		$tbl[$idx][1] = $month;
		$tbl[$idx][2] = $months{$month};
		$ctotals{$tbl[$idx][0]} += $xfers{$tbl[$idx][0]}{$tbl[$idx][1]};
		$mtotals{$tbl[$idx][1]} += $xfers{$tbl[$idx][0]}{$tbl[$idx][1]};
		$idx++;
	}
}
my $count = $idx;

$idx=0;
my @ctbl;
foreach my $comp ( keys(%ctotals) ) {
	$ctbl[$idx][0] = $comp;
	$idx++;
}

$idx=0;
my @mtbl;
foreach my $month ( keys(%mtotals) ) {
	$mtbl[$idx][0] = $month;
	$mtbl[$idx][1] = $months{$month};
	$idx++;
}

#	print "--As is--\n";
#	for ( my $i=0; $i<$count; $i++ ) {
#		printf " %50s   %3s  %12.3f MB\n", $tbl[$i][0], $tbl[$i][1], $xfers{$tbl[$i][0]}{$tbl[$i][1]};
#	}

print "--Totals sorted by computer--\n";
foreach my $iRef ( sort { $a->[0] cmp $b->[0] } @ctbl ) {
	printf " %50s   %3s  %12.3f MB\n", $iRef->[0], "", $ctotals{$iRef->[0]};
}

print "--Totals sorted by month--\n";

foreach my $iRef ( sort { $a->[1] <=> $b->[1] } @mtbl ) {
	printf " %50s   %3s  %12.3f MB\n", "", $iRef->[0], $mtotals{$iRef->[0]};
}

print "--Sorted by computer/month--\n";

foreach my $iRef ( sort { $a->[0] cmp $b->[0] 
				|| $a->[2] <=> $b->[2] } @tbl ) {
	printf " %50s   %3s  %12.3f MB\n", $iRef->[0], $iRef->[1], $xfers{$iRef->[0]}{$iRef->[1]};
}

print "--Sorted by month/computer--\n";

foreach my $iRef ( sort { $a->[2] <=> $b->[2]
				|| $a->[0] cmp $b->[0] } @tbl ) {
	printf " %50s   %3s  %12.3f MB\n", $iRef->[0], $iRef->[1], $xfers{$iRef->[0]}{$iRef->[1]};
}


exit;

