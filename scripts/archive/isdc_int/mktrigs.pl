#!/usr/bin/perl 
use File::Basename;

if ((!@ARGV) or ($ARGV[0] eq "--h")) {
  print "USAGE:  mktrigs.pl <indir> <outdir> <type> [<match>]\n";
  exit;
}

my $indir = $ARGV[0];
my $outdir = $ARGV[1];
my $type = $ARGV[2];

my $match = $ARGV[3];


print "Finding files in $indir, creating triggers of type $type in $outdir, matching $match\n";
my @files = sort timetag glob("${indir}/*");
die "No files found in $indir\n" unless (@files);

my $one;
my $tmpmtch;
foreach $one (@files) {
  $tmpmtch = $match;
  $one = File::Basename::fileparse($one,'\..*'); 
  if ($match) {
    next if (($tmpmtch =~ /^\w/) && (!($one =~ /$tmpmtch/)));
    next if (($tmpmtch =~ s/^-//) && ($one =~ /$tmpmtch/));
  }
  print "file is $one\n";
  if (($type =~ /scw/) || ($type =~ /inp/)) {
    next unless ($one =~ /^\d{12}$/);
    $one .= ".trigger";
  }
  elsif ($type =~ /rev/) {
    
    ($one =~ s/isgri_raw_noise_(\d{14}_\d{2})/$1_irn/) or
      ($one =~ s/ibis_raw_veto_(\d{14}_\d{2})/$1_irv/) or  
	($one =~ s/irem_raw_(\d{14}_\d{2})/$1_ire/) or
	  ($one =~ s/isgri_raw_cal_(\d{14}_\d{2})/$1_irc/) or
	    ($one =~ s/ibis_raw_tver_(\d{14}_\d{2})/$1_itv/) or
	      ($one =~ s/ibis_raw_dump_(\d{14}_\d{2})/$1_idp/) or
		($one =~ s/jemx(\d)_raw_frss_(\d{14}_\d{2})/$2_jm$1/) or
		  ($one =~ s/jemx(\d)_raw_dump_(\d{14}_\d{2})/$2_j$1d/) or
		    ($one =~ s/jemx(\d)_raw_dfeedump_(\d{14}_\d{2})/$2_j$1f/) or
		      ($one =~ s/jemx(\d)_raw_diag1d_(\d{14}_\d{2})/$2_j$1g/) or 
			($one =~ s/jemx(\d)_raw_tver_(\d{14}_\d{2})/$2_j$1t/) or 
			($one =~ s/jemx(\d)_raw_ecal_(\d{14}_\d{2})/$2_j$1e/) or 

			  ($one =~ s/omc_raw_bias_(\d{14}_\d{2})/$1_obc/) or
			    ($one =~ s/omc_raw_dark_(\d{14}_\d{2})/$1_odc/) or
			      ($one =~ s/omc_raw_flatfield_(\d{14}_\d{2})/$1_ofc/) or
				($one =~ s/omc_raw_sky_(\d{14}_\d{2})/$1_osc/) or
				  ($one =~ s/omc_raw_dump_(\d{14}_\d{2})/$1_omd/) or
				    ($one =~ s/omc_raw_tver_(\d{14}_\d{2})/$1_omt/) or
				      ($one =~ s/spi_raw_ocur_(\d{14}_\d{2})/$1_soc/) or
					($one =~ s/spi_raw_ecur_(\d{14}_\d{2})/$1_sec/) or
					  ($one =~ s/spi_raw_ccur_(\d{14}_\d{2})/$1_scc/) or  
					    ($one =~ s/spi_raw_dcur_(\d{14}_\d{2})/$1_sdc/) or  
					      ($one =~ s/spi_raw_tver_(\d{14}_\d{2})/$1_stv/) or
						($one =~ s/spi_raw_dump_(\d{14}_\d{2})/$1_sdp/) or
						($one =~ s/spi_raw_(as|df|pd)dump_(\d{14}_\d{2})/$2_s$1/) or
						      ($one =~ s/spi_acs_cal_(\d{14}_\d{2})/$1_sac/) or
							($one =~ s/picsit_raw_cal_(\d{14}_\d{2})/$1_prc/) or
							  ($one =~ s/sc_raw_tref_(\d{14}_\d{2})/$1_sct/) or

							  die "ERROR: trigger of one $one not matched\n";
    my $revno = $indir;
    $revno =~ s:.*\/(\d{4})\/.*:$1:;
    $one = "${revno}_${one}.trigger";
  } # if type rev
  else {
    die "ERROR:  unknown type $type\n";
  }
  print "trigger is $one\n";
  if (glob("${outdir}/${one}*")) {
    print "already exists\n";
    next;
  }
  open(TRIG,">${outdir}/${one}");
  close(TRIG);
} # foreach file

sub timetag {
  $basea = File::Basename::fileparse($a,'\..*'); 
  $baseb = File::Basename::fileparse($b,'\..*'); 
  $basea =~ s/.*\w+_(\d{14})$/$1/;
  $baseb =~ s/.*\w+_(\d{14})$/$1/;
  $basea <=> $baseb;
}
    
