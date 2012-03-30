#! /bin/sh
eval '  exec perl -x $0 ${1+"$@"} '
#! perl -s

#	Can't use -w and use strict when using -s
#	-w
#use strict;

use lib "/home/isdc/wendt/local/lib";
use lib "/Users/jake/local/lib";
use LWP::Simple;

my %reference;			#	hash of references in the format   $reference{2006ApJ...1} = N, where N is the occurence order
my $refcounter = 0;	#	incremented for each NEW occurence to keep them in order

open FILE1, "> file.tex";
open LOG  , "> process.log";

while (<>) {
	#
	#	Expecting lines with a format similar to ...
	#
	#	LEDA 168563 & 04 52 04.7 & $+$49 32 45 & 157.252 & 3.419 & 0.00028 & -- & -- & -- & 0.029 & Sey-1 & 7104 & 2002LEDA..........P, 1998A\&AS..132..341M  \\ 
	#
	if ( /^(\\| )/ ) {	#	if the line begins with a SPACE or a \, just print it and move on
		print $_;	#	this line could go stray
		next;
	}
	chomp;
	my @fields = split / & /;

	foreach my $field ( @fields ) {
		next if ( $field eq $fields[11] );						#	print all fields except the code field
		next if ( $field eq $fields[$#fields] );				#	print all fields except the last one (same as below but more clear)
		printf FILE1 ( "%s \& ", $field );
	}

	#	Then begin processing the last field.
	my @refs = split /,/, $fields[$#fields];
	foreach my $ref ( @refs ) {
		chomp $ref;
		$ref =~ s/\\\\//;		#	remove the double backslashes
		$ref =~ s/\s*//g;		#	remove any space
		$reference{$ref} = ++$refcounter unless ( exists $reference{$ref} );	#	increment the counter only if reference is NEW
	}

	my $comma = 0;		#	used to flag the need for a comma (false only for the first loop)
	my %seen = ();
	#	sort by reference occurence number and NOT the order in this line
	#	the "grep { !$seen{$_}++ }" is to prevent multiple references of the same item in one line (ie. 1,1,1,1)
	#	( basically if NOT seen (yet) ++ (which makes it true) return the value )
	foreach my $ref ( sort { $reference{$a} <=> $reference{$b} } ( grep { !$seen{$_}++ } @refs ) ) {		
		chomp;
		print FILE1 "," if ( $comma );
		print FILE1 "$reference{$ref}";
		$comma = 1;		#	set the comma flag so that any more occurences will be preceded by a flag
	}

	print FILE1 " \\\\ \n";
	print FILE1 "\\noalign{\\smallskip}\n";
}

close FILE1;

open REFS, "> refs.tex";
open BIBTEX, "> bib.tex";	
foreach ( sort { $reference{$a} <=> $reference{$b} } ( keys %reference ) ) {
	print REFS "\[$reference{$_}\] \\citet{$_}\n";

	if ( $bib ) {
		s/\\\&/\&/;
		print "Getting URL data for $_\n";
		my $URL = "http://adsabs.harvard.edu/cgi-bin/nph-bib_query?bibcode=$_&data_type=BIBTEX&db_key=AST%26amp;nocookieset=1";
		my $content;
	
		my $tries = 0;
		do {
			$content = LWP::Simple::get $URL;
			$tries++;
			print "tries: $tries\n";
		} until ( ( defined ($content) ) || ( $tries >= 5 ) );

		unless ( defined ($content) ) {
#		unless (defined ($content = get $URL)) {
			print     "could not get $URL\n";
			print LOG "could not get $URL\n";
		} else {
			print LOG "\n\n------------------------------------------------------\n\n\n";
			print LOG "$_";
			print LOG "\n\n------------------------------------------------------\n\n\n";
			print LOG "$content\n";

			if ( $content =~ /HTML/ ) {
				print     "HTML match in $URL\n";
				print LOG "HTML match in $URL\n";
			}
	
			my @lines = split "\n", $content;
			foreach my $line ( @lines ) {
				next if ( $line =~ /^Retrieved/ );
				next if ( $line =~ /^Query Results from the ADS Database/ );
				print BIBTEX "$line\n";
			}
		}
	}
}
close REFS;
close BIBTEX;
close LOG;

exit;

