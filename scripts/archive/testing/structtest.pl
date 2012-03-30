#!/usr/bin/perl -w

#use strict;
#use ISDCStep;

use Class::Struct;

struct Step => {
   name => '$',
   func => '$',
};

my $step = Step->new("testname");
$step->name("testname");
printf "%s", $step->name;

my @steps;
push @steps, Step->new("testname", "testfunc1" );
print $steps[0]->name."\n";


push @steps, Step->new("testname", "testfunc1" );
push @steps, Step->new("testname2", "testfunc2(1,2,3,4)" );

print $steps[0]->func;

exit;

####################################################################################################

sub testfunc1 {
	print "in testfunc1 @_\n";
}

sub testfunc2 {
	print "in testfunc2 @_\n";
}


__END__

use Class::Struct; # load struct-building module
struct Person => { # create a definition for a "Person"
	name => '$', # name field is a scalar
	age => '$', # age field is also a scalar
	peers => '@', # but peers field is an array (reference)
};
my $p = Person->new(); # allocate an empty Person struct
$p->name("Jason Smythe"); # set its name field
$p->age(13); # set its age field
$p->peers( ["Wilbur", "Ralph", "Fred" ] ); # set its peers field
# or this way:
@{$p->peers} = ("Wilbur", "Ralph", "Fred");
# fetch various values, including the zeroth friend
printf "At age %d, %s's first friend is %s.\n", $p->age, $p->name, $p->peers(0);






