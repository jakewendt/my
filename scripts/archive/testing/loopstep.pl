#!/usr/bin/perl -w

use strict;
use testclass2;

my @testarr;
for (1..10) { 
	push @testarr, testclass2->new;
	#	print $testarr[$_-1],"\n";
	print testclass2->population,"\n";
}

for (1..10) { 
	$testarr[$_-1]->DESTROY;
#		OR
#	testclass2->DESTROY;
	print testclass2->population,"\n";
}

testclass2->new("testname");
print testclass2->myname,"\n";




exit;





