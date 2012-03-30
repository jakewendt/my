#!/usr/bin/perl -w

my $line = "23467232456";
my $char = '2';
my @match;

print "$line matches $char\n" if ( $line =~ /$char/ );

( @match ) = ( $line =~ /$char/g );
print "\@match : ",@match,"\n";
print "\$#match : ",$#match,"\n";
print "\$match[0] : ",$match[0],"\n";
print "\$match[1] : ",$match[1],"\n";


for ( my $i=1; $i<=9; $i++ ) {
	print "Checking $i in $line.\n";
	( @match ) = ( $line =~ /$i/g );
	print "Found $i ( $#match ) that could be set in row $row\n" if ( $#match == 0 );
	last if ( $#match == 0 );
}


