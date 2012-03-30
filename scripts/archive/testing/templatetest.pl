#!/usr/bin/perl -w

use ISDCPipeline;

   my @raw_list = ();
   my $gziplist = "";                      #       primarily a list of .gz files
   my $fitslist = "";                      #       primarily a list of .fits files

   open TEMPLATEFILE, "$ENV{CFITSIO_INCLUDE_FILES}/GNRL_SCWG_RAW.cfg" or die "*******     ERROR:  Could not open GNRL_SCWG_RAW.cfg";
   while (<TEMPLATEFILE>) {
      chomp;
      next if ( !/^\s*file / );
      s/^\s*file //;
      push @raw_list, "$_";
   }
   close TEMPLATEFILE;




foreach ( @raw_list ) {
	print "$_\n";
}







exit;


