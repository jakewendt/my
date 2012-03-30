#!/usr/bin/perl -w

use strict;

my $filename = "update";
my $FUNCNAME = "updateInstall";
my $FUNCVERSION = "1.0";

#exit unless ( $#ARGV >= 0 );

#	loop through all parameters that begin with - until one doesn't have a leading - 
if ( defined ($ARGV[0]) ) {
	while ($_ = $ARGV[0], /^-.*/) {
		if ( /-h/ ) {
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
		elsif ( /-v/ ) {
			print "Log_1  : Version : $FUNCNAME $FUNCVERSION\n";
			exit 0;
		}
		else {  # all other cases
			print "ERROR: unrecognized option +$ARGV[0]+.  Aborting...\n";
			print "\n";
#			exit 1;
		}
		shift @ARGV;
	}     # while options left on the command line
} else {
	
}


print $filename."\n";
open CURFILE, $filename;
while (<CURFILE>) {
	chomp;
	print "\n###   Checking +$_+\n";
	next if ( /^\s*#/ ) ;
	next if ( /^\s*$/ ) ;

	my ( $compname, $compver ) = ( /^\s*different\s+(\w+)\s+([\d\.]+)\s+[\d\.]+\s*$/ );
	print "###   compname +$compname+\n";
	print "###   compver  +$compver+\n";

	print "###   Installing $compname-$compver\n";
	system ( "mkdir $compname-$compver" ) unless ( -e "$compname-$compver" );
	chdir "$compname-$compver" or die "Cannot chdir $compname-$compver";
	my $tarfile = "/home/isdc/isdc_lib/archive/deliveries/$compname-$compver.tar.gz";
	die "$tarfile not readable" unless ( -r "$tarfile" );
	system ( "gtar xfz $tarfile" );
	system ( "configure" );
	system ( "make" );
	system ( "make install" );

	system ( "mv $ENV{ISDC_ENV}/VERSION $ENV{ISDC_ENV}/VERSION.old" );
	open OVERSION, "< $ENV{ISDC_ENV}/VERSION.old";
	open NVERSION, "> $ENV{ISDC_ENV}/VERSION";
	while ( <OVERSION> ) {
		if ( /^\s*#/ ) {
			print NVERSION $_;
			next;
		}
		my ( $name, $ver ) = ( /^\s*(\w+)\s+([\d\.]+)\s*/ );
		if ( $name eq $compname ) { 
			print NVERSION "$compname		$compver\n";
		} else { 
			print NVERSION $_;
		}
	}
	close OVERSION;
	close NVERSION;

	chdir ".." or die "Cannot chdir ..";
	print "###   Done installing $compname-$compver\n";
}
close CURFILE;

print "\n###   All done.\n\n";

exit;



