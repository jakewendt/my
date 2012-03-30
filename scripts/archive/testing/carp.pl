#!/usr/bin/perl -w

#	I guess this is like my previously written ISDCLIB::Error

use Carp;

&one();

print "After Croak\n";

exit;

sub one {
	&two();
}
sub two {
	&three();
}
sub three {

	&Carp::confess ( "Test" );

}
