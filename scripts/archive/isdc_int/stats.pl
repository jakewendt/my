#!/isdc/refsoftware/bin/perl -w

use strict;
$| = 1;

my $filename = "testlog";
my $outfile  = "outfile";
my $FUNCNAME = "ftpstats";
my $FUNCVERSION = "1.0";

#exit unless ( $#ARGV >= 0 );

#       loop through all parameters that begin with - until one doesn't have a leading - 
if ( defined ($ARGV[0]) ) {
	while ( $_ = $ARGV[0] ) {
	#while ($_ = $ARGV[0], /^-.*/) {
		if ($_ eq "-h"			||
			$_ eq "--h"			||
			$_ eq "--help") {
			print "\n\n"
				."Usage:  $FUNCNAME  [options] file(s)\n"
				."\n"
				."  -f, --f, --filename -> logfile to parse\n"
				."  -o, --o, --outfile  -> output file \n"
				."  -v, --v, --version  -> version number\n"
				."  -h, --h, --help     -> this help message\n"
				."\n\n"
				; # closing semi-colon
				exit 0;
		} 
		elsif ( /-o/ ) {
			shift @ARGV;
			$outfile = $ARGV[0];
		} 
		elsif ( /-f/ ) {
			shift @ARGV;
			$filename = $ARGV[0];
		} 
		elsif ($_ eq "-v"		||
			$_ eq "--v"			||
			$_ eq "--version") {
			print "Log_1  : Version : $FUNCNAME $FUNCVERSION\n";
			exit 0;
		} else {  # all other cases
			print "ERROR: unrecognized option +$ARGV[0]+.  Aborting...\n";
			print "\n";
			exit 1;
		}
		shift @ARGV;
	}     # while options left on the command line
}

#	exit unless ( $#ARGV >= 0 );

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

#Mon Jul 12 18:16:25 2004 0 pulsar.nsstc.nasa.gov 72000 /export/diskA2/home/ftp/arc/rev_1/scw/0050/005000100010.001/swg_osm.fits b _ o r iswt_ftp ftp 0 * c

my $entries = 0;
my $total   = 0;
my $linenum = 0;
my %xfers;

open INFILE, "${filename}" or die "Cannot open ${filename}";
while (<INFILE>) {
	$linenum++;
	my (     $wday,     $mth,     $day,        $hr,     $min,   $sec,    $year,    $x,       $comp,    $size ) = 
		( /^(\w{3})\s+(\w{3})\s+(\d{1,2})\s+(\d{1,2}):(\d{2}):(\d{2})\s+(\d{4})\s+(\d+)\s+([\w\d\.\-]+)\s+(\d+)/ );
	
	print "$_" unless defined $wday;

	#	print "     $wday,     $mth,     $day,        $hr,     $min,   $sec,    $year,    $x,       $comp,    $size \n";
	$size /= 1000000;
	$total += $size;
	printf " Line# %12d   Current %20.6f MB | Total %20d MB\r", $linenum, $size, $total;		#	IF I'M IN THE FOREGROUND (would be nice)
	$xfers{$comp}{$mth} += $size;
}
close INFILE;

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

open OUTFILE, ">> ${outfile}";
print OUTFILE "--As is--\n";
for ( my $i=0; $i<$count; $i++ ) {
	printf OUTFILE " %50s   %3s  %12.3f MB\n", $tbl[$i][0], $tbl[$i][1], $xfers{$tbl[$i][0]}{$tbl[$i][1]};
}

print OUTFILE "--Totals sorted by computer--\n";
foreach my $iRef ( sort { $a->[0] cmp $b->[0] } @ctbl ) {
	printf OUTFILE " %50s   %3s  %12.3f MB\n", $iRef->[0], "", $ctotals{$iRef->[0]};
}

print OUTFILE "--Totals sorted by month--\n";
foreach my $iRef ( sort { $a->[1] <=> $b->[1] } @mtbl ) {
	printf OUTFILE " %50s   %3s  %12.3f MB\n", "", $iRef->[0], $mtotals{$iRef->[0]};
}

print OUTFILE "--Sorted by computer/month--\n";
foreach my $iRef ( sort { $a->[0] cmp $b->[0] 
				|| $a->[2] <=> $b->[2] } @tbl ) {
	printf OUTFILE " %50s   %3s  %12.3f MB\n", $iRef->[0], $iRef->[1], $xfers{$iRef->[0]}{$iRef->[1]};
}

print OUTFILE "--Sorted by month/computer--\n";
foreach my $iRef ( sort { $a->[2] <=> $b->[2]
				|| $a->[0] cmp $b->[0] } @tbl ) {
	printf OUTFILE " %50s   %3s  %12.3f MB\n", $iRef->[0], $iRef->[1], $xfers{$iRef->[0]}{$iRef->[1]};
}
close OUTFILE;

exit;

