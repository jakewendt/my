#!/usr/bin/perl -w

use strict;

#use TestObject;	#	not needed since included code

my $val = new TestObject("none");

print $val->variable2()."\n";
print $val->variable2('really new value')."\n";

$val->test();

exit;


######################################################################

{
	package TestObject;

	sub new {
		my $self = shift;				#	required
		my $class = ();				#	required
		$class->{name} = shift;		#	something required
		$class->{variable2} = shift || 10;	#	optional variables
		$class->{variable3} = shift || 10;	#	optional variables
		bless $class;					#	required
		return $class;					#	required
	}

	sub variable2 { 
		if ( $_[1] ) {
			$_[0]->{variable2} = $_[1];
		}
		return $_[0]->{variable2}; 
	}	#	$_[0] is the same as "my $self = shift;"


	sub test {
		my ( $self ) = @_;
		print "$self->{name}\n";;
	}

}
