#!/isdc/sw/perl/5.6.0/WS/7/bin/perl
##!/usr/bin/perl -w
##!/isdc/sw/perl/5.6.1/WS/7/bin/perl 
#	actually this is now 5.8.4
#	this is 5.005_03 and it will chomp a read-only array

#use strict;

#	do not work with @_!  Copy it to something else.  @_ can be read only depending on the version of perl.
#	You may also be modifying the actual passed variable, which may or may not be what you want.

@array =  qw/one two three four five/;

print "Before ", @array, "\n";
&changeArray ( @array );
&changeArray ( "a", "b", "c" );

print "After  ", @array, "\n";


sub changeArray () {
	@array = @_;
	print "In     ", @array, "\n";
	$array[0] = 'six';
	chomp $array[0];
	return;
}

