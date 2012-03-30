#!/usr/bin/perl -s


#	057400120021_isgri.trigger
#	057400130010_isgri.trigger
#	057400130021_isgri.trigger
#	057400140010_isgri.trigger

open SKY, "> no_isgri_sky_ima_exists_for";
open MOS, "> isgri_mosa_ima_exists_for";
open INP, "> triggerlist";
open DONE, "> processed";
#	/reproc/cons/ops_sa/obs_isgri/0040.000/ssii_004000060180/scw/004000060180.001/


my $OBSDIR = "$ENV{REP_BASE_PROD}/obs_isgri_osa_7v0";
chdir $OBSDIR;
foreach my $rev ( glob ( "${r}.000" ) ) {
	chdir $rev;
	print $rev."\n";
	foreach my $ssii ( glob ( "ssii_????????????" ) ) {
		chdir $ssii;
		print $ssii."\n";
		my ( $scw ) = ( $ssii =~ /ssii_(\d{12})/ );
		print $scw."\n";

		unless ( -e "isgri_catalog.fits.gz" ) {

			#	if isgri_catalog.fits.gz does not exist, then it has only been partially processed

			print INP "touch ${scw}_isgri.trigger\n" 
		} else {
			print DONE "$scw\n";

			#	usually both of these lists will be the same
			#	if a scw is in either of these lists, it should probably not be ingested

			print SKY "$OBSDIR/$rev/ssii_$scw\n" unless ( `ls -1 scw/$scw.???/isgri_sky_ima.fits.gz` );
#			print SKY "$scw\n" unless ( -e "scw/$scw.001/isgri_sky_ima.fits.gz" );
			print MOS "$OBSDIR/$rev/ssii_$scw\n" if ( -e "isgri_mosa_ima.fits.gz" );
		}

		chdir "..";
	}
	chdir "..";
}

close DONE;
close INP;
close MOS;
close SKY;

