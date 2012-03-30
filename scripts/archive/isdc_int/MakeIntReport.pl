#! /bin/sh
eval '  exec perl -x $0 ${1+"$@"} '
#!/usr/bin/perl 
=start
exit; 
__END__
=cut
# -----------------------------------------------------------------------------
# Name:     MakeIntReport.pl
# Purpose:  To generate an Integration report from the VERSION and a source
# Date:     041006
# Author:   Jake Wendt
# Version:  0.03
#
# Revisions: 
# 041006 - Jake Wendt - 0.03
#  added consssa to list
# 
# 031201 - Jake Wendt - 0.02
#  added nrtqla, conssa, consscw, consinput, consrev, adp, and arcdd to list
# 
# 031124 - Jake Wendt - 0.01
# - Initial creation.
#------------------------------------------------------------------------------

use File::Basename;

#------------------------------------------------------------------------------
# Initializations
#------------------------------------------------------------------------------
$FUNCNAME    = basename($0);
$FUNCVERSION = 0.03;

#------------------------------------------------------------------------------
# Command line argument processing.
#------------------------------------------------------------------------------
while ($_ = $ARGV[0], /^-.*/) {
	
	if ($_ eq "-h"     ||
		$_ eq "--h"    ||
		$_ eq "--help") {
		print 
		"\n\n"
			."Usage:  MakeIntReport.pl  VERSION  SourceTemplate\n"
			."\n"
		; # closing semi-colon
		
		exit 0;
	}
	
	elsif ($_ eq "-v"        ||
		$_ eq "--v"       ||
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


if ($#ARGV != 1) {
	print "\n" 
		."$FUNCNAME ERROR: Expecting two arguments\n"
		."Aborting... \n\n";
	exit 2;
}

$file1=$ARGV[0];
$file2=$ARGV[1];

if ((! -f $file1) || (! -f $file2)) {
	print "\n";
	if (! -f $file1) {
		print "ERROR: VERSION not found: + $file1 +\n";
	}
	if (! -f $file2) {
		print "ERROR: SourceTemplate not found: + $file2 +\n";
	}
	print "  Aborting...\n";
	print "\n";
	exit 2;
}

#------------------------------------------------------------------------------
# Populating the hash ( Main program )
#------------------------------------------------------------------------------


&readFile($file1, version1);
&printIntegrationReport ( $file2 );

exit 0;


#------------------------------------------------------------------------------
# End Main program
#------------------------------------------------------------------------------




#------------------------------------------------------------------------------
# Function
#------------------------------------------------------------------------------
sub readFile {
	
	local $file    = $_[0];
	local $version = $_[1];
	
	open(FILE,"<$file") or 
	&die("Could not open file + $file +",(caller(0))[3]);
	
	while (<FILE>){
		$line = $_;
		
		last if ($line eq "__END__\n");      # Anything past __END__ is ignored.
		next if (index($line,"#") == 0);     # ignore comments
		next if (m/^\s*\n$/);                # skip {0,n} whitespace lines
		
		@words = split(' ',$line);
		$compName = @words[0];
		$comp{$compName}{$version} = @words[1];
	}
	
	close FILE;
}



#------------------------------------------------------------------------------
# Function
#------------------------------------------------------------------------------
sub printIntegrationReport {
	
	local $file    = $_[0];
	local $version = $_[1];
	
	open(FILE,"<$file") or 
		&die("Could not open file + $file +",(caller(0))[3]);
	
	while (<FILE>){
		$line = $_;
		
		last if ($line eq "__END__\n");      # Anything past __END__ is ignored.
		if (index($line,"#") == 0) {
		print $line;     # ignore comments
		next;
	}
	elsif (m/^\s*\n$/) {
		print $line;                # skip {0,n} whitespace lines
		next;
	}
	elsif ( /Insert ALL_SW.header/ ) {
		open HEADER, "< ALL_SW.header";
		while (<HEADER>) {
			print $_;
		}
		close HEADER;
		next;
	}
	
	@words = split(' ',$line);
	$compName = @words[0];
	if ( $compName eq "nrtscw"      ||
		$compName eq "nrtrev"      ||
		$compName eq "nrtinput"    ||
		$compName eq "nrtqla"      ||
		$compName eq "consinput"   ||
		$compName eq "conssa"      ||
		$compName eq "consssa"     ||
		$compName eq "consscw"     ||
		$compName eq "consrev"     ||
		$compName eq "adp"         ||
		$compName eq "arcdd"       ||
		$compName eq "pipeline_lib" ) {
		
		printf ("%-25s  %-12s\n", 
			$compName, 
			$ENV{${compName}."Ver"} );
#			@words[1] );
	next;
	
}

$comp{$compName}{$version} = @words[1];

printf ("%-25s  %-12s\n"
	, $compName
	, $comp{$compName}{version1}
	);

}

close FILE;
}



__END__


#last line
