#!/usr/bin/perl -w

use strict;
use File::Basename;

my $FUNCNAME = "OLFMerge";
my $FUNCVERSION = "1.0";

my $outdir  = "OLFMergeOut";

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

#	must be 2 filenames given
unless ( $#ARGV == 1 ) {
	print "$FUNCNAME requires 2 filenames\n";
	exit;
}

unless ( -d $outdir ) {
	print "Creating output directory :$outdir\n";
	print `mkdir $outdir 2>&1`;
}

my $oldfile = "$ARGV[0]";
my $newfile = "$ARGV[1]";
if ( $oldfile eq $newfile ) {
	print "$FUNCNAME requires 2 DIFFERENT filenames\n";
	exit;
}
print "newfile: $newfile\n";
print "oldfile: $oldfile\n";



my $outfile = "$outdir/".basename($oldfile);
my $tcfile  = "$outdir/".basename($oldfile)."-OldTC";
print "outfile: $outfile\n";
print "tcfile : $tcfile \n";

open OLDFILE, "< $oldfile";
open NEWFILE, "< $newfile";
open OUTFILE, ">> $outfile";
open TCFILE,  ">> $tcfile";

my $oldline = <OLDFILE>;
my $newline = <NEWFILE>;

while ( ( $oldline ) || ( $newline ) ) {

	while ( ( $oldline ) && ( $oldline =~ /TIME_CORRELATION/ ) ) {
		print "Skipping TIME_CORRELATION record in OLDFILE $oldfile\n";
		print TCFILE $oldline;
		#	$oldline = <OLDFILE>;
		while ( $oldline = <OLDFILE> ) {
			if ( $oldline =~ /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/ ) {
				last;
			} else {
				print TCFILE $oldline;
			}
		}
	}

	( my $oldtime = $oldline ) =~ s/^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})Z.*$/$1$2$3$4$5$6/ if ( $oldline ); 
	( my $newtime = $newline ) =~ s/^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})Z.*$/$1$2$3$4$5$6/ if ( $newline ); 
	chomp $oldtime if ( $oldtime );
	chomp $newtime if ( $newtime );
	print "OLDTIME $oldtime\n" if ( $oldtime );
	print "NEWTIME $newtime\n" if ( $newtime );

	if ( ( $oldtime ) && ( $newtime ) ) {

		if ( $oldtime < $newtime ) {
			print "oldtime < newtime\n";
			print OUTFILE $oldline;
			#	$oldline = <OLDFILE>;
			while ( $oldline = <OLDFILE> ) {
				if ( $oldline =~ /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/ ) {
					last;
				} else {
					print OUTFILE $oldline;
				}
			}

		} else {
			print "oldtime > newtime\n";
			print OUTFILE $newline;
			#	$newline = <NEWFILE>;
			while ( $newline = <NEWFILE> ) {
				if ( $newline =~ /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/ ) {
					last;
				} else {
					print OUTFILE $newline;
				}
			}
		}

	} elsif ( $oldtime ) {
			print "Only OLDTIME found\n";
			print OUTFILE $oldline;
			#	$oldline = <OLDFILE>;
			while ( $oldline = <OLDFILE> ) {
				if ( $oldline =~ /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/ ) {
					last;
				} else {
					print OUTFILE $oldline;
				}
			}

	} elsif ( $newtime ) {
			print "Only NEWTIME found\n";
			print OUTFILE $newline;
			#	$newline = <NEWFILE>;
			while ( $newline = <NEWFILE> ) {
				if ( $newline =~ /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/ ) {
					last;
				} else {
					print OUTFILE $newline;
				}
			}
	}


}


close OLDFILE;
close NEWFILE;
close OUTFILE;
close TCFILE;

exit;



