#!/usr/bin/perl -w

$ENV{COMMONLOGFILE} = "+";
my $extname;

my ($retval,@result) = `/isdc/integration/isdc_int/sw/nrt_sw/13.2.3/bin/dal_list /isdc/integration/isdc_int/sw/nrt_sw/prod/opus/consscw/unit_test/out/scw/0025/002500000061.000/swg.fits+1 extname=$extname exact=n longlisting=yes fulldols=no mode`;

my $donotcountlist;	# = "-SPI.-OME2-ALL-SPI.-OMP5-ALL SPI.-OMP6-ALL";
my $cur_struct;
my $cur_rows;
my $rows;                              #  undefined variable
foreach ( @result ) {                  #  loop through all lines of output
	#chomp;                              #  remove \n (not sure if this is completely necessary)
                                       #  may work without if remove the last $ from the next line
	next unless /Rows=\s+(\d+)\s*$/;    
	$cur_rows = $1;
	
	#	Log_1  : SPI.-OMP3-ALL        TABLE Cols=         8, Rows=      2086
	/^\s*Log_1\s+:\s+([\w\.-]{13})\s+/;
	$cur_struct = $1;

	print $_;
	print "-$cur_struct-\n";

	$rows += $cur_rows unless $donotcountlist =~ /$cur_struct/;    #  Sum up all the Rows except if in $donotcountlist
	print "$rows\n";
}
$rows = -1 if !defined($rows);         #  return -1 if no match


print "$rows\n";


exit;


