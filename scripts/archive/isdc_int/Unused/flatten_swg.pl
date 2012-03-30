#!/usr/bin/perl -w

use strict;

my $filename = "";
my $FUNCNAME = "flatten_swg";
my $FUNCVERSION = "1.0";

exit unless ( $#ARGV >= 0 );

#	loop through all parameters that begin with - until one doesn't have a leading - 
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

exit unless ( $#ARGV >= 0 );

#	loop through all the rest after the first without a leading -
while ( $ARGV[0] ) {
	$filename = $ARGV[0];
#	print $filename."\n";

	my @data = ();
	my @location = ();
	my $newlocation = "";

#	print `fdump ${filename}\[1] STDOUT columns=MEMBER_LOCATION rows=- prhead=no page=no showcol=no`;

	foreach (  `fdump ${filename}\[1] STDOUT columns=MEMBER_LOCATION rows=- prhead=no page=no showcol=no` ) 
	{
		next unless ( /^\s*[\d]+\s+[\w\.\/]+\s*$/ );
		next if ( /\.\./ );		#	ignore ../../../aux/adp/blah blah blah
		@data = split;

		@location = split /\//, $data[1];
		$newlocation = $location[$#location];

		foreach ( `fdump ${filename}\[1] STDOUT columns=MEMBER_LOCATION rows=$data[0] prhead=no page=no showcol=no` )
		{
			print "old : $_" if ( /^\s*[\d]+\s+[\w\.\/]+\s*$/ );
		}

#
#ibis_diagnostic                                               <
#ibis_diagnostic                                               <
#                                                              > ibis_prp_diag
#                                                              > ibis_raw_diag
#jmx1_diag                                                     <
#jmx1_diag                                                     <
#                                                              > jmx1_prp_diag
#                                                              > jmx1_raw_diag
#jmx2_diag                                                     <
#jmx2_diag                                                     <
#                                                              > jmx2_prp_diag
#                                                              > jmx2_raw_diag
#
		$newlocation = "ibis_raw_diag" if ( $data[1] =~ /eng\/raw\/ibis_diagnostic/ );
		$newlocation = "ibis_prp_diag" if ( $data[1] =~ /eng\/prp\/ibis_diagnostic/ );
		$newlocation = "jmx1_raw_diag" if ( $data[1] =~ /eng\/raw\/jmx1_diag/ );
		$newlocation = "jmx1_prp_diag" if ( $data[1] =~ /eng\/prp\/jmx1_diag/ );
		$newlocation = "jmx2_raw_diag" if ( $data[1] =~ /eng\/raw\/jmx2_diag/ );
		$newlocation = "jmx2_prp_diag" if ( $data[1] =~ /eng\/prp\/jmx2_diag/ );

		print `fpartab $newlocation ${filename}\[1]  MEMBER_LOCATION $data[0]`;
		foreach ( `fdump ${filename}\[1] STDOUT columns=MEMBER_LOCATION rows=$data[0] prhead=no page=no showcol=no` )
		{
			print "new : $_" if ( /^\s*[\d]+\s+[\w\.\/]+\s*$/ );
		}

	}

	shift @ARGV;
}     # while options left on the command line

exit;



