#!/usr/bin/perl -w

   my %pars = (
      "step"                   => "INST name gti_merge",
      "program_name"           => "gti_merge",
      "par_InSWGroup"          => "",
      "par_OutSWGroup"         => "swg.fits[1]",
      "par_MergedName"         => "name",
      "par_OutInstrument"      => "INST",
      "par_SC_Names"           => "ATTITUDE",
      "par_SPI_Names"          => "",
      "par_IBIS_Names"         => "",
      "par_JEMX1_Names"        => "",
      "par_JEMX2_Names"        => "",
      "par_OMC_Names"          => "",
      "par_IREM_Names"         => "",
      "par_GTI_Index"          => "",
      "par_BTI_Dol"            => "bti",
      "par_BTI_Names"          => "",
      );

foreach ( keys(%pars ) ) {
	print "$_ : $pars{$_}\n";
}

print "\n\n\n";

      $pars{"par_SC_Names"}       = "ATTITUDE OSM1";


foreach ( keys(%pars ) ) {
	print "$_ : $pars{$_}\n";
}





exit;


