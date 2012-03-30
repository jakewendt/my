#!/usr/bin/perl -w

my $i = 0;


foreach ( 
"aca/spi_cal_me_spectra.fits" ,
"aca/spi_cal_se_spectra.fits" ,
"aca/spi_gain_coeff.fits" ,
"aca/spi_cal_me_results.fits" ,
"aca/spi_cal_se_results.fits" ,
"aca/spi_cal_re_results.fits" ,
) {
	if ( /ecs|spi_psd|hk_averages|spi_gain_coeff|spi_cal_[ms]e_results|spi_cal_[ms]e_spectra/) {
		print "match    : $_ \n" ;
	} else {
		print "no match : $_ \n";
	}

}


