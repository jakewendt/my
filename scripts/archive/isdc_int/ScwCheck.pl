#!/usr/bin/perl -w

use File::Basename;
use strict;

exit unless ( $#ARGV >= 0 );

my $scw = "";
my $FUNCNAME = "ScwCheck";
my $FUNCVERSION = "1.0";

my $dallist = 1;
my $findcheck = 1;
my $parselog;
my $fstruct;
my $group = 1;

$ENV{COMMONLOGFILE} = "+$ENV{HOME}/common_log.txt";

#	loop through all parameters that begin with - until one doesn't have a leading - 
if ( defined ($ARGV[0]) ) {
	while ($_ = $ARGV[0], /^-.*/) {
		if ($_ eq "-h"          ||
			$_ eq "--h"             ||
			$_ eq "--help") {
				print 
					"\n\n"
					."Usage:  $FUNCNAME  [options] file(s)\n"
					."\n"
					."  -v, --v, --version -> version number\n"
					."  -h, --h, --help    -> this help message\n"
					."     by default, parcheck only compares parameter names\n"
					."\n\n"
				; # closing semi-colon
				exit 0;
			}
		elsif ($_ eq "-v"               ||
			$_ eq "--v"                     ||
			$_ eq "--version") {
				print "Log_1  : Version : $FUNCNAME $FUNCVERSION\n";
				exit 0;
		}
		else {  # all other cases
			print "ERROR: unrecognized option +$ARGV[0]+.  Aborting...\n";
			print "\n";
			exit 1;
		}
		shift @ARGV;
	}     # while options left on the command line
} else {
		#	Or else what?
}

exit unless ( $#ARGV >= 0 );



#	loop through all the rest after the first without a leading -
while ( $ARGV[0] ) {
	$scw = $ARGV[0];
	my ( $revno ) = ( $scw =~ /^(\d{4})/ );
	my %files;

	open TEMPLATEFILE, "$ENV{CFITSIO_INCLUDE_FILES}/GNRL_SCWG_GRP.cfg"
		or die "*******     ERROR:  Could not open GNRL_SCWG_GRP.cfg";
	while (<TEMPLATEFILE>) {
		chomp;
		next unless ( /^\s*file\s+/ );
		next if ( /GNRL-FILE-GRP/ );
		#  file spi_raw_oper_tmp GNRL-FILE-GRP
		s/^\s*file\s+//;
		s/\s+[\w-]+\s*$//;
		$files{template}{$_} = "";
	}
	close TEMPLATEFILE;

	print "Beginning check of $ENV{REP_BASE_PROD}/scw/$revno/$scw\n";

	my @dal_list_out = `cd $ENV{REP_BASE_PROD}/scw/$revno/$scw/.; dal_list swg.fits+1 fulldols=y`;

	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

	if ( $dallist ) {
		#print "Parsing dal_list $ENV{REP_BASE_PROD}/scw/$revno/$scw/swg.fits\n";

		my $dol;
		foreach ( @dal_list_out ) {
			next unless ( /^Log_2/ );			#	only the filenames
			next unless ( /${scw}/ );			#	ignores aux data and such
			( $dol ) = ( /Log_2  : (.*)$/ );
			# ( $dol = $_ ) =~ s/(Log_2  : )//;
			my ($root,$path,$suffix) = File::Basename::fileparse($dol,'\..*');
			next if ( $root eq "swg" );
			print "- NOT IN TEMPLATE ---> $dol\n" unless ( exists $files{template}{$root} );	# || ( exists $files{dal}{$root} ));
			$files{dal}{$root} = 1;
		}
	}
	
	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

	if ( $findcheck ) {
		#print "Checking $ENV{REP_BASE_PROD}/scw/$revno/$scw for extra files\n";

		foreach my $file ( `cd $ENV{REP_BASE_PROD}/scw/$revno/$scw/.; find .` ) {
			chomp $file;
			next if ( $file eq "." );
			next if ( $file =~ /swg.fits/ );
			next if ( $file =~ /${revno}.*_\w{3}.txt/ );
			if ( $file eq "./raw" ) {
				print "- NOTE :  raw data exists.  arc_prep has probably not run for this yet.\n";
			}
			next if ( $file =~ /swg_raw.fits/ );
			next if ( $file =~ /^\.\/raw/ );
			( my $root = $file ) =~ s/^\.\///;
			$root =~ s/\.gz$//;
			$root =~ s/\.fits$//;
			$files{find}{$root} = 1;
			print "- NOT ATTACHED    ---> $ENV{REP_BASE_PROD}/scw/$revno/$scw/$file\n"
				unless ( ( exists $files{dal}{$root} ) && ( exists $files{template}{$root} ) );
		}
	}


#	Verify that all structures in a given file are attached to the group or an index that is attached to the group
#	fstruct 
#	   4  BINTABLE OMC.-GNRL-GTI   8     96(6) 0                     0    1
#     3  IMAGE    PICS-SIMH-RAW   8     256 64 64                   0    1


	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

	if ( $fstruct ) {
		#print "Searching for unattached structures\n";

		my $dol;
		foreach ( @dal_list_out ) {
			next unless ( /^Log_2/ );			#	only the filenames
			next unless ( /${scw}/ );			#	ignores aux data and such
			( $dol ) = ( /Log_2  : (.*)$/ );
			my ($root,$path,$suffix) = File::Basename::fileparse($dol,'\..*');
			next if ( $root eq "swg" );
			$files{dal2}{$root} = $files{dal2}{$root} + 1 if ( exists $files{dal2}{$root} );;
			$files{dal2}{$root} = 1 unless ( exists $files{dal2}{$root} );;
		}
		foreach my $dol ( keys(%{$files{dal2}}) ) {
			my $fstructcount = `fstruct $ENV{REP_BASE_PROD}/scw/$revno/$scw/$dol.fits | grep BINTABLE | wc -l`;
			$fstructcount += `fstruct $ENV{REP_BASE_PROD}/scw/$revno/$scw/$dol.fits | grep IMAGE | wc -l`;
			print "- UNATTACHED STRUCT IN ---> $ENV{REP_BASE_PROD}/scw/$revno/$scw/$dol.fits\n" if ( $files{dal2}{$dol} < $fstructcount );
			print "- MULTIPLE ATTACHED ?? ---> $ENV{REP_BASE_PROD}/scw/$revno/$scw/$dol.fits\n" if ( $files{dal2}{$dol} > $fstructcount );
		}
	}


	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

	if ( $group ) {
		#print "Searching for unattached structures (2)\n";
		my $dol;
		foreach ( @dal_list_out ) {
			next unless ( /^Log_2/ );			#	only the filenames
			next unless ( /${scw}/ );			#	ignores aux data and such
			next if ( /swg.fits/ );
			( $dol ) = ( /Log_2  : (.*)$/ );
			my ($root,$path,$suffix) = File::Basename::fileparse($dol,'\..*');
			#print "root:$root\n";
			#print "path:$path\n";
			#print "suffix:$suffix\n";
			my ( $struct ) = ( $suffix =~ /fits\[([\-\.\w]{13}),/ );
			#print "struct:$struct\n";

			$files{dal3}{$root}{$struct} = 1;
			$files{names}{$root}{$struct} = 1;		#	must use a single list for name in case dal_list or fstruct have extra
		}
		foreach my $root ( keys(%{$files{find}}) ) {
			next if ( $root eq "raw" );

			foreach ( `fstruct $ENV{REP_BASE_PROD}/scw/$revno/$scw/$root.fits` ) {
				chomp;
				next unless ( /^\s+\d+\s+\w+\s+[\-\.\w]{8,13}\s+\d+\s+\d+/ );
				my ( $struct ) = ( /^\s+\d+\s+\w+\s+([\-\.\w]{8,13})\s+\d+\s+\d+/ );
				$files{fst}{$root}{$struct} = $files{fst}{$root}{$struct} + 1 if ( exists $files{fst}{$root}{$struct} );;
				$files{fst}{$root}{$struct} = 1 unless ( exists $files{fst}{$root}{$struct} );;
				$files{names}{$root}{$struct} = 1;
			}
		}

		foreach my $root ( keys(%{$files{names}}) ) {
			foreach my $struct ( keys(%{$files{names}{$root}}) ) {
				my $temp = "$root"."[$struct]";


#	fdiff 000280730051.001/sc_gti.fits+1 000280730051.001/swg.fits+7 | 
#		/usr/xpg4/bin/grep -Ev "CREATOR|DATASUM|DATE|EXTVER|REVOL|GRPID1|col 6|col 5" | grep "^>"

				if ( $struct eq "GROUPING" ) {
					#print ("- Comparing GROUPING" );
					my $num = grep /GROUPING/, @dal_list_out;
					#print (" - found $num GROUPINGs\n" );
					for ( my $i=2; $i<($num+2); $i++ ) {
						my @numdiffs = `cd $ENV{REP_BASE_PROD}/scw/$revno/$scw/.; fdiff $root.fits\[GROUPING] swg.fits+$i | \
							/usr/xpg4/bin/grep -Ev "CREATOR|DATASUM|DATE|EXTVER|REVOL|GRPID1|col 6|col 5" | grep "^>"`;
						#my @numdiffs = `cd $ENV{REP_BASE_PROD}/scw/$revno/$scw/.; \
						#		fdiff $root.fits\[GROUPING] swg.fits+$i exclude = "CREATOR, DATASUM, DATE, EXTVER, REVOL, GRPID1" | \
						#		/usr/xpg4/bin/grep -Ev "col 5|col 6" | grep "^>"`;
						#		#	columns 5 and 6 are used to specify the location of the structure and are therefore different
						#		#/usr/xpg4/bin/grep -Ev "CREATOR|DATASUM|DATE|EXTVER|REVOL|GRPID1|col 6|col 5" | grep "^>"`;
						if ( $#numdiffs <= 0 ) {			# -1 when no diffs
							#print "$root.fits+1 swg.fits+$i = SAME : $#numdiffs\n";
							last;
						} else {
							#print "$root.fits+1 swg.fits+$i = DIFF : $#numdiffs\n";
							print "- NO MATCH FOUND for unattached $temp in swg.fits\n" if (( $i == $num+1 ) && 
								( $temp !~ /picsit_histo_simh\[GROUPING\]/ ) && ( $temp !~ /picsit_histo_sish\[GROUPING\]/ )) ;
						}
					}

					next;
				}

				printf ("- STRUCT %40s does not exist in dal_list hash\n", $temp ) 
					unless ( ( exists $files{dal3}{$root}{$struct} )
						#	any of the raw stuff
						|| ( $temp =~ /^raw/ )
						|| ( $temp eq "swg_raw[GROUPING]" )

						#	the GTIs are just copied to these files for scientist convenience
						|| ( $temp eq "spi_oper[SPI.-GNRL-GTI]" )
						|| ( $temp eq "spi_diag[SPI.-GNRL-GTI]" )
						|| ( $temp eq "isgri_events[IBIS-GNRL-GTI]" )
						|| ( $temp eq "picsit_events[IBIS-GNRL-GTI]" )
						|| ( $temp eq "jmx1_events[JMX1-GNRL-GTI]" )
						|| ( $temp eq "jmx2_events[JMX2-GNRL-GTI]" )

						#	I'm working on a better check for this to ensure that these are indices
						#	and that they have actually been copied into the group file.
#						|| ( $temp eq "omc_gti[GROUPING]" )
#						|| ( $temp eq "jmx1_gti[GROUPING]" )
#						|| ( $temp eq "jmx2_gti[GROUPING]" )
#						|| ( $temp eq "ibis_gti[GROUPING]" )
#						|| ( $temp eq "spi_gti[GROUPING]" )
#						|| ( $temp eq "sc_gti[GROUPING]" )
#						|| ( $temp eq "picsit_histo_simh[GROUPING]" )
#						|| ( $temp eq "picsit_histo_sish[GROUPING]" )
						);
				printf ("- STRUCT %40s does not exist in fstruct hash\n" , $temp ) unless ( exists $files{fst}{$root}{$struct} );
				next unless ( ( exists $files{dal3}{$root}{$struct} ) && ( exists $files{fst}{$root}{$struct} ) );

			}
		}
	}




	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

	if ( $parselog ) {
		print "Parsing _scw.txt log file for errors\n";
		open CURFILE, `ls $ENV{REP_BASE_PROD}/scw/$revno/$scw/*_scw.txt`;
		while (<CURFILE>) {
			#	next if ( /^Log_/ );
			#	next if ( /^-----/ );
			#	next unless ( ( /Error/i ) || ( /warn/i ) || ( /ISDC_OK/i ) || ( /rev.-01/i ));
			next unless ( ( /^Error/i ) || ( /^Warn/i ) );
	
			#Warn_3  2004-09-20T09:17:21 dp_average 1.5: There are no data to average for the OMC.-FLAT-AVG average table.
			next if ( /Warn.*dp_average.*There are no data to average for the/ );
	
			#Warn_1  2004-09-20T09:06:03 evts_pick 3.1.1: No SPI events of type SPI.-CCRV-ALL
			next if ( /Warn.*evts_pick.*No.*events of type/ );
	
			#Warn_1  2004-09-18T11:54:11 spi_dp_derived_param 1.0.4: There are no P__PD__NB_MME__L18 data. Filling the output column with NULL values
			next if ( /Warn.*spi_dp_derived_param.*There are no.*Filling the output column with NULL values/ );
	
			#Warn_2  2004-09-20T09:09:58 osm_const_param 1.0.1: Cannot find table SPI.-480E-HRW in previous science windows.
			next if ( /Warn.*osm_const_param.*Cannot find table.*in previous science windows/ );
	
			#Warn_0  2004-09-18T12:01:14 ibis_prp_check_histo 1.1: too low rate found 0.000000 at OBTIME 2664563736576
			next if ( /Warn.*ibis_prp_check_histo.*too low rate found.*at OBTIME/ );
	
			#Warn_2  2004-09-16T15:33:30 osm_timeline 1.13a: About to flush all DAL buffers, however an error has occurred.
			next if ( /Warn.*About to flush all DAL buffers, however an error has occurred/ );
	
			#Warn_2  2004-09-16T15:34:47 osm_timeline 1.13a: There may be data loss, and the program may crash!
			next if ( /Warn.*There may be data loss, and the program may crash!/ );
	
			print "- FOUND IN LOG    ---> $_";
		}
		close CURFILE;
	}

	#print "Done checking $ENV{REP_BASE_PROD}/scw/$revno/$scw\n\n";

	shift @ARGV;
}     # while options left on the command line

exit;



