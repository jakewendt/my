#!/usr/bin/perl -w

use strict;

my $FUNCNAME = "compare_scripts";
my $FUNCVERSION = "1.0.20040324";
my $tarfile = "";

#exit unless ( $#ARGV >= 0 );

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
#                exit 1;
        }
        shift @ARGV;
}     # while options left on the command line

#exit unless ( $#ARGV >= 0 );

#	loop through all the rest after the first without a leading -
#while ( $ARGV[0] ) {
#	$filename = $ARGV[0];
#	print $filename."\n";
#	open CURFILE, $filename;
#	while (<CURFILE>) {
#		print $_;
#	}
#	close CURFILE;
#	shift @ARGV;
#}     # while options left on the command line

my $component = $ARGV[0];
my $oldVer    = $ARGV[1];
my $newVer    = $ARGV[2];

foreach ( ${oldVer}, ${newVer} )
{
	rmdir $_;
	mkdir $_, 0755;
	chdir $_;
	$tarfile = "/home/isdc/isdc_lib/archive/deliveries/${component}-$_.tar.gz";
	if ( -r $tarfile ) {
		`tar xvfz ${tarfile} \`tar ztf ${tarfile} | /usr/xpg4/bin/grep -iE '.(par)\$'\``;
#		`tar xvfz ${tarfile} \`tar ztf ${tarfile} | /usr/xpg4/bin/grep -iE '.(C|par)\$'\``;
	} else {
		die "-- ${tarfile} not readable.";
	}	#	could I just use a `this` or die; statement here?
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

print "diff --suppress-common-lines -rybwBqds ./${oldVer} ./${newVer}\n";
my @differlist = `diff --suppress-common-lines -rybwBqds ./${oldVer} ./${newVer}`;

my @newdifflist;
foreach ( @differlist )
{
	next if /are identical/;
	chomp;
	s/\s*$//;				#	remove any trailing white space
	s/^\s*//;				#	remove any leading white space

	#	Files ./5.4/ii_spectral/regress.C and ./5.5/ii_spectral/regress.C differ
	s/^Files [\w\d\.\/]* and \.\/${newVer}\///;
	s/\s*differ\s*$//;
	#	ii_spectral/regress.C

	push @newdifflist, $_;		#	a list of files that have changed without version numbers and stuff
	#print "$_\n";
}



my @parlist = ();
my $parfile = "";
my $cfile = "";
my ($par,$type,$mode,$default,$min,$max,$comment);
my @details = ();

foreach ( @newdifflist )
{

	if ( /Only in/ ) {
		print "\n$_\n\n";
		next;
	}
	print "\ndiff --suppress-common-lines -rBbwd ./${oldVer}/${_} ./${newVer}/${_}\n\n";
	#print `diff --suppress-common-lines -rBbwd ./${oldVer}/${_} ./${newVer}/${_}`;
	foreach ( `diff --suppress-common-lines -rBbwd ./${oldVer}/${_} ./${newVer}/${_}` ) {
		next if ( /> # GUI/ );
		next if ( /< # GUI/ );
		print $_;
	}

#	if ( /par$/ ) {
#		print "\nOH MY GOD!  The par files differ!\n\n";
#		next;
#	}	#	else ( I hope ) its a C file that differs.
#
#	print "\nChecking $_ files for parameter usage. \n\n";
#
#	@parlist = ();
#	$cfile = $_;
#	$parfile = $_;
#	$parfile =~ s/[Cc]$/par/;		#	a parfile of the same name as the C file (not all exist)
#
#	#	Not all of these will exist, ie...
#	#	ii_spectral/regress.par
#	#	only if dirname and filename the same ???
#
#	if ( -r "${newVer}/${parfile}" ) {
#		open (PARS,"${newVer}/${parfile}") or die "Cannot open ${newVer}/${parfile}\n";
#
#		while(<PARS>) {
#			next if /^\s*#/ ;		#	remove comment only lines
#			next if /^\s*$/ ;		#	remove blank lines
#			($par,$type,$mode,$default,$min,$max,$comment) = ParParse("$_");
#			$par =~ s/\s+//g;		#	remove any multiple white spaces
#			$par =~ s/^SCW1_//;
#			$par =~ s/^SCW2_//;
#			$par =~ s/^OBS1_//;
#			$par =~ s/^OBS2_//;
#
#			#	NO indenticals and NOT brief
#			foreach ( `diff --suppress-common-lines -ryBbwd ./${oldVer}/${cfile} ./${newVer}/${cfile}` )
#			{
#				print $_ if /${par}/;
#			}
#			#	grep $par detaileddifference > selecteddifferences ???	
#			#print "$par\n";
#		}
#
#		close PARS;
#	} else {
#		print "File ${newVer}/${parfile} does not exist or is unreadable.\n";
#		next;
#	}
}









exit;

  
#  This is straight out of the Perl cookbook, pg 31, sect 1.15:
sub ParParse {
  
  my $text = shift;
  my @new = ();
  push(@new,$+) while $text =~ m{
                                 "([^\"\\]*(?:\\.[^\"\\]*)*)",?
                                 |  ([^,]+),?
                                 | ,
                                }gx;
  push(@new,undef) if substr($text, -1,1) eq ',';
  return @new;

}
