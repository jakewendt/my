#! /bin/sh
eval '  exec perl -x $0 ${1+"$@"} '
#! perl -s

use File::Basename;
use VLIB;

$| = 1;

=head1

=item
Hi Jake,

as discussed yesterday, we now simulated for each of our sources in our AGN sample 1000 lightcurves with similar characteristics as the measured data. These lightcurves we would now like to process through the same program you did some time ago in order to compute the variability estimator (sigma_Q).
Again, it would be good to keep the interface in a way that we can feed a list of source names into it, in case we have to do another processing with different data.

All the lightcurves are under

/unsaved_data/beckmann/SwiftXLF/BAT_light/only_AGN/dwell/simul

For each source there are two files (e.g. for NGC1142):
NGC1142_20_simul_lc.fits
NGC1142_20_simul_lc_err.fits
[the 20 indicates that we simulate here the 20day binned lightcurves]

The first one contains the flux values for 1000 lightcurves (1 lightcurve per row). In this case there are 13 time bins in each lightcurve (for other sources this can be between 12 and 15).
The errors are stored in a similar structure in the file
NGC1142_20_simul_lc_err.fits

There can be negative flux values, but there should not be any negative error value.

As an output the best would be one fits file per source, containing each 1000 rows with the sigma_Q values. From there I can compute the corrected variability estimator and then look into the distribution in order to figure out the (hopefully small!) error of the estimator.

Let me know if you need more information.

Cheers
Volker

=cut

foreach my $file ( @ARGV ) {
	print "$file \n";
	( my $file_err = $file ) =~ s/\.fits/_err.fits/;
	print "$file_err \n";
	`rm temp.fits` if ( -e 'temp.fits' );
	`fimg2tab fitsfile=$file outfile=temp.fits cols=- rows=-`;
	my @flux_lines = `fdump infile=temp.fits outfile=STDOUT columns=- rows=- prhead=no pagewidth=256 page=no wrap=yes showrow=no showunit=no showscale=no showcol=n`;
	shift @flux_lines until $flux_lines[0] !~ /^\s*$/;

	`rm temp.fits` if ( -e 'temp.fits' );
	`fimg2tab fitsfile=$file_err outfile=temp.fits cols=- rows=-`;
	my @err_lines = `fdump infile=temp.fits outfile=STDOUT columns=- rows=- prhead=no pagewidth=256 page=no wrap=yes showrow=no showunit=no showscale=no showcol=n`;
	shift @err_lines until $err_lines[0] !~ /^\s*$/;

	if ( scalar(@flux_lines) != scalar(@err_lines) ) {
		print "For some reason the number of lines in the flux and error tables don't match!\n";
		print "Num flux lines : ",scalar(@flux_lines),"\n";
		print "Num err lines : ",scalar(@err_lines),"\n";
		exit;
	}

	my ($root,$path,$ext) = &File::Basename::fileparse($file,'\..*');

#	open FILE, "| fcreate cdfile=output.cdf outfile=output/$root-sigma_q.fits datafile=-";
	open FILE, "> output/$root-sigma_q.txt";

	foreach my $row ( 0..$#flux_lines ) {
#	foreach my $row ( 0..30 ) {
		my @x = split /\s+/, @flux_lines[$row];
		shift @x until $x[0] !~ /^\s*$/;
		my @sigma = split /\s+/, @err_lines[$row];
		shift @sigma until $sigma[0] !~ /^\s*$/;
		if ( scalar(@x) != scalar(@sigma) ) {
			print "For some reason the number of columns in the x and sigma tables don't match!\n";
			print "Num x columns : ",scalar(@x),"\n";
			print "Num sigma columns : ",scalar(@sigma),"\n";
			exit;
		}
		my $x_sum = 0;
		my $sum1 = 0;
		my $sum2 = 0;

		foreach my $i ( 0..$#x ) {
			die "OMG!  Negative error value!  $sigma[$i] for column $i!" if ( $sigma[$i] < 0 );
			print "x: $x[$i]\n" if ( $debug );
			print "sigma: $sigma[$i]\n" if ( $debug );
			$x_sum += $x[$i];
			$sum1 += $x[$i] / $sigma[$i] / $sigma[$i];
			$sum2 += 1 / $sigma[$i] / $sigma[$i];
			print "i:$i : x[i]:$x[$i] sigma[i]:$sigma[$i] x_sum:$x_sum sum1:$sum1 sum2:$sum2\n" if ( $debug );
#			print "$i     $x[$i]    $sigma[$i]    9\n";
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
	
		printf ( "$row:Best sigma_Q for %-86s : %15.10e : estimator : %15.8f\n", $file, $best_sigma_Q, $best_estimator );
		printf FILE "%15.10e  %15.8f\n", $best_sigma_Q, $best_estimator;
#		print FILE "$best_sigma_Q \t $best_estimator\n";
	}
	close FILE;
}
