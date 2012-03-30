#!/usr/bin/perl -w

use package1;	#	contains &mytestroutine;
use package2;

print "Packages.pl test start.\n";

&pkg1test;

print "Packages.pl test middle.\n";

&pkg2test;

print "Packages.pl test end.\n";


exit;



