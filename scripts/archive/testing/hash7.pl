#!/usr/bin/perl -w

use strict;

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
$pars{"par_OutInstrument"} .= "appended";

%pars = (
		%pars,
      "par_JEMX1_Names"        => "x",
      "par_JEMX2_Names"        => "x",
		"xxxx" => $ENV{ISDC_ENV}."[ISGRI_FLAG==1 && ISGR_FLUX_1>100]",
      "step"                   => "x",
      "program_name"           => "x",
      "par_InSWGroup"          => "x",
      "par_OutSWGroup"         => "x",
      "par_MergedName"         => "x",
      "par_OutInstrument"      => "x",
      "par_SC_Names"           => "x",
      "par_SPI_Names"          => "x",
      "par_IBIS_Names"         => "x",
      "par_JEMX1_Names"        => "x",
      "par_JEMX2_Names"        => "x",
      "par_OMC_Names"          => "x",
      "par_IREM_Names"         => "x",
      "par_GTI_Index"          => "x",
      "par_BTI_Dol"            => "x",
      "par_BTI_Names"          => "x",
);


foreach ( keys(%pars ) ) {
	print "$_ : $pars{$_}\n";
}





exit;


