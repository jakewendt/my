#! /bin/sh
eval '  exec perl -x $0 ${1+"$@"} '
#! perl -w

use strict;

my %reference;			#	hash of references in the format   $reference{2006ApJ...1} = N, where N is the occurence order
my $refcounter = 0;	#	incremented for each NEW occurence

open FILE1, "> file1.tex";
open FILE2, "> file2.tex";
open FILE3, "> file3.tex";
open FILE4, "> file4.tex";
open FILE5, "> file5.tex";

select FILE1;		#	potential problem as I have no reason to know which is actually first.

while (<>) {
	if ( /^(\\| )/ ) {	#	if the line begins with a SPACE or a \, just print it and move on
		print $_;	#	this line could go stray
		next;
	}
	chomp;
	my @fields = split / & /;

#	Find the "CODE" in order to select the file
#     0      1     2        3          4         5       6    7    8     9     10        11             12
#	IGR 41 & 00 & $+$61 & 119.614 & $-$0.999 & 0.05000 & -- & 570 & -- & 0.3 & CV (IP) & 1640 & ph..3715B, 2006A\&A...455...11M  \\
	if ( ( $fields[11] >= 1100 ) && ( $fields[11] < 1400 ) ) {
		select FILE1;
	} elsif ( ( $fields[11] >= 1400 ) && ( $fields[11] < 1600 ) ) {
		select FILE2;
	} elsif ( ( $fields[11] >= 1600 ) && ( $fields[11] < 5000 ) ) {
		select FILE3;
	} elsif ( ( $fields[11] >= 5000 ) && ( $fields[11] < 9999 ) ) {
		select FILE4;
	} elsif ( ( $fields[11] >= 1000 ) && ( $fields[11] < 1100 ) ) {
		select FILE5;
	} else { 
		die "$_ failed to match a specific CODE";
	}

	foreach my $field ( @fields ) {
		next if ( $field eq $fields[11] );						#	print all fields except the code field
		next if ( $field eq $fields[$#fields] );				#	print all fields except the last one (same as below but more clear)
#		next unless ( $field cmp $fields[$#fields] );		#	print all fields except the last one
		printf ( "%s \& ", $field );
	}

	#	Then begin processing the last field.

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
	foreach my $ref ( sort { $reference{$a} <=> $reference{$b} } ( grep { !$seen{$_}++ } @refs ) ) {		
		chomp;
		print "," if ( $comma );
		print "$reference{$ref}";
		$comma = 1;		#	set the comma flag so that any more occurences will be preceded by a flag
	}

	print " \\\\ \n";
}

close FILE1;
close FILE2;
close FILE3;
close FILE4;
close FILE5;

open REFS, "> refs.tex";
select REFS;
foreach ( sort { $reference{$a} <=> $reference{$b} } ( keys %reference ) ) {
	print "($reference{$_}) $_\n";
}
close REFS;

select STDOUT;	#	probably not necessary
