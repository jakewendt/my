#!/isdc/sw/perl/5.6.1/WS/7/bin/perl -w
##!/isdc/sw/perl/5.6.0/WS/7/bin/perl -w
##!/usr/bin/perl -w	#	this is 5.005_03 and it will chomp a read-only array

#use strict;


chomptest ( "a", "b", "c" );	#	this will fail
&chomptest ( "a", "b", "c" );	#	this will fail


my @arr = ( "a\n", "b\n", "c\n" );
print @arr;
print "-\n";
&chomptest ( @arr );					#	this works
print @arr;
print "-\n";

exit;

sub chomptest {
#	print "@_";
	my @vals = @_;

	foreach my $val ( @vals ) {
		chomp ($val);
		print "$val\n";
	}
}

#	do not work with @_!  Copy it to something else.  @_ can be read only depending on the version of perl.
#	You may also be modifying the actual passed variable, which may or may not be what you want.

