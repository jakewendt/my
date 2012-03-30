#! /bin/sh
eval '  exec perl -x $0 ${1+"$@"} '
#! perl -w

use strict;

my %reference;			#	hash of references in the format   $reference{2006ApJ...1} = N, where N is the occurence order
my $refcounter = 0;	#	incremented for each NEW occurence

while (<>) {
	if ( /^(\\| )/ ) {	#	if the line begins with a SPACE or a \, just print it and move on
		print $_;
		next;
	}
	chomp;
	my @fields = split / & /;
	foreach ( @fields ) {
		next unless ( $_ cmp $fields[$#fields] );
		printf ( "%s \& ", $_ );
	}

#	print scalar(@fields)."\n";	#	the number of fields (ie. $#field + 1 )
#	print scalar($#fields)."\n";	#	the subscript of the LAST field

	my @refs = split /,/, $fields[$#fields];
	foreach ( @refs ) {
		chomp;
		s/\\\\//;		#	remove the double backslashes
		s/\s*//g;		#	remove any space
		$reference{$_} = ++$refcounter unless ( exists $reference{$_} );	#	increment the counter only if reference is NEW
	}

	my $comma = 0;		#	used to flag the need for a comma (false only for the first loop)
	my %seen = ();
	#	sort by reference occurence number and NOT the order in this line
	#	the "grep { !$seen{$_}++ }" is to prevent multiple references of the same item in one line (ie. 1,1,1,1)
	#	( basically if NOT seen (yet) ++ (which makes it true) return the value )
	foreach ( sort { $reference{$a} <=> $reference{$b} } ( grep { !$seen{$_}++ } @refs ) ) {		
		chomp;
		print "," if ( $comma );
		print "$reference{$_}";
		$comma = 1;		#	set the comma flag so that any more occurences will be preceded by a flag
	}




	print " \\\\ \n";
}

print "\n\n\n";

foreach ( sort { $reference{$a} <=> $reference{$b} } ( keys %reference ) ) {
	print "($reference{$_}) $_\n";
}


