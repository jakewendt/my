#!/usr/bin/perl -w

use strict;

foreach my $revno ( `ls -d /isdc/arc/rev_1/scw/02*` ) 
{	
	print $revno;
	chomp $revno;
	foreach my $file ( `ls ${revno}/0*/*/raw/*fits*` )
	{
		chomp $file;
		foreach ( `fkeyprint $file  STAMP` ) 
		{
			chomp;
			next if ( /^\s*#/ );
			next if ( /^\s*$/ );
	#		next if ( /^STAMP/ );
			next if ( /Preproc/ );	#	way too many
			next if ( /ibis_spih_obt_calc/ );		#	picsit_raw_histo_si[ms]h
			next if ( /spi_merge_schk/ );				#	don't care
			printf ( "%-70s : %-40s\n", $file, $_ );
		}
	}
}



