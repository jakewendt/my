#!/usr/bin/perl -w

use strict;


my ( $ret1a, $ret1b ) = &Return1;
print "$ret1a, $ret1b\n";

my ( $ret2a, $ret2b ) = &Return2;
print "$ret2a, $ret2b\n";

my ( $ret1 ) = &Return1;
print "$ret1\n";

my ( $ret2 ) = &Return2;
print "$ret2\n";

&Call1 ( 1 );
&Call1 ( 1, 2 );

&Call2 ( 1 );
&Call2 ( 1, 2 );

exit;

##################################################

sub Call1 {
	my ( $var ) = @_;
	print "Call1 - $var\n";
}

sub Call2 {
	my ( $var1, $var2 ) = @_;
	print "Call2 - $var1, $var2\n";
}


sub Return1 {

	return ( 1 );

}

sub Return2 {

	return ( 1, 2 );

}


