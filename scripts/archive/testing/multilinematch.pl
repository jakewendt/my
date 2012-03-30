#!/usr/bin/perl -w 

#  Example idx2dol output
#idx2dol index="/isdc/integration/isdc_int/sw/dev/prod/opus/nrtscw/unit_test/outref/scw/0025/002500010010.000/swg.fits[GROUPING,7,BINTABLE]" 
#     select="GTI_NAME == 'SC'" numLog=0


push my @results, "Log_1  : Selection [GTI_NAME == 'SC'] (1 members.) NumLog : 1";
push    @results, "Log_0  : /isdc/integration/isdc_int/sw/dev/prod/opus/nrtscw/unit_test/outref/scw/0025/002500010010.000/intl_osm_gti.fits[INTL-GNRL-GTI,5,BINTABLE]";


my $gtidol;
my $usenextline = "";
print "Searching idx2dol output for structure location.\n";
foreach (@results) {
	chomp;
	if ( $usenextline =~ /YES/ ) {
		( $gtidol ) = ( /Log_0\s+\:\s+(.*)\s*$/ );
		last;
	}
	$usenextline = "YES" if ( /members/ );
}
print ( "No match found in idx2dol output.\n" ) unless ( $gtidol );
print ( "gtidol is $gtidol.\n" ) if ( $gtidol );


exit;


