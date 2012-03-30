#!/usr/bin/perl -w

use ISDCPipeline;

   my @raw_list = ();
   my $gziplist = "";                      #       primarily a list of .gz files
   my $fitslist = "";                      #       primarily a list of .fits files

   open TEMPLATEFILE, "/isdc/isdc_tst/rev_2/sw/cons_sw/cons_sw-13.0.10/templates/GNRL_SCWG_GRP.cfg" 
		or die "*******     ERROR:  Could not open GNRL_SCWG_GRP.cfg";

   while (<TEMPLATEFILE>) {
      chomp;
      next if ( !/^\s*file / );
      s/^\s*file\s+//;
		s/\s+[\w-]+\s*$//;		#	file spi_raw_oper_tmp GNRL-FILE-GRP
      push @raw_list, "$_";
   }
   close TEMPLATEFILE;




foreach ( @raw_list ) {
	print "$_\n";
}







exit;


