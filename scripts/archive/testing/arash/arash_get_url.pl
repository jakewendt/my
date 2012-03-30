#! /bin/sh
eval '  exec perl -x $0 ${1+"$@"} '
#! perl


use strict;
use lib "/home/isdc/wendt/local/lib";
use lib "/Users/jake/local/lib";
#use lib "$ENV{HOME}/local/lib/";
use LWP::Simple;
use File::Basename;
use CGI; # qw(:standard);

open BIBTEX, "> bib.tex";	
open LOG, "> geturl.log";

while (<>) {
	chomp;
	next if ( /^\s*$/ );
#	\[438\] \citet{2006A\&A...446.1095B}
	my ( $code ) = ( /citet\{(\S+)\}/ );
	$code =~ s/\\\&/\&/;

	print "$code\n";
	my $content;
	my $URL = "http://adsabs.harvard.edu/cgi-bin/nph-bib_query?bibcode=$code&data_type=BIBTEX&db_key=AST%26amp;nocookieset=1";

	my ( $level, $number );

	unless (defined ($content = get $URL)) {
		print     "could not get $URL\n";
		print LOG "could not get $URL\n";
	} else {
		print LOG "\n\n------------------------------------------------------\n\n\n";
		print LOG "$code";
		print LOG "\n\n------------------------------------------------------\n\n\n";
		print LOG "$content\n";

#		open  BIBTEX1, "> tmp/$code.tex";
#		print BIBTEX1 "$content\n";
#		close BIBTEX1;

		my @lines = split "\n", $content;
		foreach my $line ( @lines ) {
			next if ( $line =~ /^Retrieved/ );
			next if ( $line =~ /^Query Results from the ADS Database/ );
			print BIBTEX "$line\n";
		}
	}
}

close BIBTEX;
close LOG;

exit;


