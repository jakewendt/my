#!/usr/bin/perl -w

use strict;

my $TAR = "/unige/gnu/bin/tar";
my $filename = "";
my $component = "";
my $newversion = "";
my $oldversion = "";
my $tarfile = "";
my $FUNCNAME = "par_compare";
my $FUNCVERSION = "1.0";

#exit unless ( $#ARGV >= 0 );

#	loop through all parameters that begin with - until one doesn't have a leading - 
while ($_ = $ARGV[0], /^-.*/) {
	if ( /-h/ ) {
		print 
		"\n\n"
		."Usage:  $FUNCNAME  [options] file(s)\n"
		."\n"
		."  -v, --v, --version -> version number\n"
		."  -file, --file, -filename -> component list file format : component #.#.# (changed from #.#.#)\n"
		."  -h, --h, --help    -> this help message\n"
		."\n\n"
		; # closing semi-colon
		exit 0;
	}
	
	elsif ( /-v/ ) {
		print "Log_1  : Version : $FUNCNAME $FUNCVERSION\n";
		exit 0;
	}
	elsif ( /-file/ ) {
		shift @ARGV;
		$filename = $ARGV[0];	# unless $ARGV[0] == "";
	}
	
	else {  # all other cases
		print "ERROR: unrecognized option +$ARGV[0]+.  Aborting...\n";
		print "\n";
		exit 1;
	}
	shift @ARGV;
}     # while options left on the command line

die "No filename given\n" unless ( $filename );

mkdir "./par_compare/", 0755;
chdir "./par_compare/";

open CURFILE, $filename;
while (<CURFILE>)							#	loop through all components in component list file
{
	#
	#	looking for lines like ...
	#	ibis_isgr_low_thres           3.0         (changed from 2.3)
	#
	next unless ( /\(changed from / );		#	a changed component
	print $_;
	
	my @stuff = split;
	
	$component = $stuff[0];
	$newversion = $stuff[1];
	$oldversion = $stuff[4];		#	2.3)
	$oldversion =~ s/\)$//;			#	2.3
	
	if ( $component =~ /_scripts/ ) {
		print "running compare_scripts.pl ${component} ${oldversion} ${newversion}\n";
		print `compare_scripts.pl ${component} ${oldversion} ${newversion}`;
		# print "done running compare_scripts.pl ${component} ${oldversion} ${newversion}\n";
		next;
	}

	mkdir "$component", 0755;
	chdir "$component";

	foreach ( ${oldversion}, ${newversion} )
	{
		rmdir $_;
		mkdir $_, 0755;
		chdir $_;
		$tarfile = "/home/isdc/isdc_lib/archive/deliveries/${component}-$_.tar.gz";
   	`$TAR xvfz ${tarfile} '\*.par' --exclude=\*unit_test\* 2> /dev/null`;
		chdir "..";
	}
	
	#	     -w  --ignore-all-space
	#	     -b  --ignore-space-change
	#	     -B  --ignore-blank-lines
	#	     -q  --brief
	#	     -y  --side-by-side
	#	     --suppress-common-lines
	#	     -r  --recursive
	#	     -s  --report-identical-files
	#	     -d  --minimal
	#
	#`diff --suppress-common-lines -rybwBqds ./${oldVer} ./${newVer} > brief`;
	#

	# print `diff --suppress-common-lines -q ./${oldversion} ./${newversion}`;
	print `diff --suppress-common-lines -yrBbwd ./${oldversion} ./${newversion}`;
	chdir "..";
}
close CURFILE;

exit;

