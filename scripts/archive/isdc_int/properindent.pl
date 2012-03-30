#!/usr/bin/perl -w

use strict;

my $FUNCNAME  = "properindent";
my $FUNCVERS  = "1.3";
my $filename  = "";
my $tabcount  = 0;
my $nocomment = "";
my $prevline  = "";
my $offset    = "";
my $indent    = "\t";
my $flush;
my $lang = "PERL"; 	#	default

exit unless ( $#ARGV >= 0 );

#       loop through all parameters that begin with - until one doesn't have a leading - 
while ($_ = $ARGV[0], /^-.*/) {
        if ($_ eq "-h"          ||
                $_ eq "--h"     ||
                $_ eq "--help") {
                print 
                "\n\n"
                ."Usage:  $FUNCNAME  [options] file(s)\n"
                ."\n"
                ."  -v, --v, --version     -> version number\n"
                ."  -h, --h, --help        -> this help message\n"
                ."  -sh, --sh              -> use bourne shell rules\n"
                ."  -html                  -> use html rules\n"
                ."  -fc, --flushcomments   -> comments flush to left margin\n"
                ."  -off=##, --offset=##   -> use ## space offset left margin\n"
                ."  -us=##, --usespaces=## -> use ## spaces to indent instead of tabs\n"
                ."\n\n"
                ; # closing semi-colon
                exit 0;
        } elsif ( /-v/ ) {
                print "Log_1  : Version : $FUNCNAME $FUNCVERS\n";
                exit 0;
        } elsif ( /-sh/ ) {
					$lang = "SH";
        } elsif ( /-off/ ) {
					my ($num) = /.*=(\d+)/;
					$offset = sprintf "%${num}s" if ($num);
        } elsif ( /-us/ ) {
					my ($num) = /.*=(\d+)/;
					$indent = sprintf "%${num}s" if defined($num);	#	allows for 0 indent (Why would you do this?)
        } elsif ( /-f[lc]/ ) {
					$flush++;
        } else {  # all other cases
                print "ERROR: unrecognized option +$ARGV[0]+.  Aborting...\n";
                print "\n";
                exit 1;
        }
        shift @ARGV;
}     # while options left on the command line

exit unless ( $#ARGV >= 0 );

#       loop through all the rest after the first without a leading -
while ( $ARGV[0] ) {
	$filename = $ARGV[0];
	open CURFILE, $filename;
	while (<CURFILE>) {
		chomp;						#	remove carriage return
		s/^\s*//g;					#	remove leading white space

		#	strip the line of comments and leading/trailing white space before processing
		$nocomment = $_;


		#	possible legitimates are \#, ^# and $#, so far.
		#	still fails on a line like
		#     }# end foreach type
		$nocomment =~ s/^(.*)[^\}\$\\\^]{1}\#.*$/$1/;					# what about legitimate #'s like this line 
		$nocomment = "" if ( $nocomment =~ /^#/ ) ;
		$nocomment =~ s/\s*$//;			#	remove trailing spaces

# The order here plays a part in the result.
# Do not move anything unless ...?

		$tabcount-- if (( $nocomment =~ /^end/ )  && ( $lang eq "SH" )); 					#	for sh scripts (end, endif, endfor)
		$tabcount-- if (( $nocomment =~ /^el/ )   && ( $lang eq "SH" ));					#	for sh scripts (else, elif) 
		$tabcount-- if (( $nocomment =~ /^fi/ )   && ( $lang eq "SH" ));					#	for sh scripts
		$tabcount-- if (( $nocomment =~ /^done/ ) && ( $lang eq "SH" ));					#	for sh scripts
		$tabcount-- if ( $nocomment =~ /^(\}|\])/ ); 
#		if  ( ( $nocomment =~ /^(\}|\])/ ) 
#			|| ( $nocomment =~ /\};*$/ ) ) {
#			$tabcount--;
#		}
		$tabcount++ if ( $prevline =~ /(\||\&)$/ );												#	keep ||'s and && indented
		$tabcount++ if ( $nocomment =~ /^\./ );													#	keep multiline prints indented
		$tabcount++ if ( $nocomment =~ /\,$/ );



		ptab ($tabcount);	# if !( $nocomment =~ /\:$/ );											#	for sh script LABELS:
		print "$_\n";		#############################################################################################
#		print "-".$nocomment."-\n";			#	line was used during testing

		$tabcount-- if ( $prevline =~ /(\||\&)$/ );												#	keep ||'s and && indented
		$tabcount-- if ( $nocomment =~ /^\./ );													#	keep multiline prints indented
		$tabcount-- if ( $nocomment =~ /\,$/ );
		$tabcount-- if ( $nocomment =~ /\};*$/ );



		$tabcount++ if (( $nocomment =~ /^foreach/ ) && ( $lang eq "SH" ));				#	for sh scripts (actually csh)
		$tabcount++ if (( $nocomment =~ /do$/ ) && ( $lang eq "SH" ));				#	for sh scripts (actually csh)
		$tabcount++ if (( $nocomment =~ /then$/ ) && ( $lang eq "SH" ));					#	for sh scripts
		$tabcount++ if (( $nocomment =~ /^el/ ) && ( $nocomment !~ /then$/ ) && ( $lang eq "SH" ));		#	for sh scripts with else if ... then

		$tabcount++ if ( $nocomment =~ /(\{|\[|\()\s*$/ );										#	open ended statement


		#	a line that begins with ) and ends with ; - the closing of a previously open ended statement
		#	it seems that sometimes whitespace becomes a problem, so I put in the before and after \s*
		$tabcount-- if ( $nocomment =~ /^\s*\)[\s\S]*\;\s*$/ );		

		#	special case for commands that are trailed by "if ( );" on a line alone
		$tabcount-- if ( $nocomment =~ /^\s*if[\s\S]*\;\s*$/ );		

		$tabcount = 0 if ( $tabcount < 0 );		#	make sure it doesn't go negative
		$prevline = $nocomment;
	}
	close CURFILE;
	shift @ARGV;
}     # while options left on the command line

exit;

sub ptab {
	my $counter = $_[0];

	return if (( $nocomment =~ /\:$/ ) && ( $lang eq "SH" ));			#	for sh script LABELS:
	return if (( $nocomment eq "" ) && ( $flush ));							#	flush comments

	print ${offset} if ( $offset );

	for ( my $i = 1; $i <= $counter ; $i++ ) {
		print ${indent};
	}
}


