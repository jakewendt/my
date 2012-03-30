#!/usr/bin/perl -w


my @arr1 = ( "A", "B", "C" );
my @arr2 = ( "1", "2", "3" );

print "1 : @arr1\n";

&addstuff ( \@arr1, \@arr2 );

print "3 : @arr1\n";

print "You are at line ".__LINE__." of ".__PACKAGE__."\n";


exit;

sub addstuff {
	my ( $a, $b ) = @_;

	print "2 : @$a\n";
	print "2 : @$b\n";

	push @$a, ( "D", "E", "F" );
	push @$b, ( "D", "E", "F" );

}

