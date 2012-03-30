#!/usr/bin/perl -w 
##!/usr/bin/perl -w -I libtest1 -I libtest2


##!/usr/bin/perl -w -I libtest1 -I libtest2	#	uses the first one

#	-I adds them to the end of the @INC array
#	use lib adds them to the beginning of @INC
#
#	libtest2
#	libtest1
#	/usr/perl5/5.00503/sun4-solaris
#	/usr/perl5/5.00503
#	/usr/perl5/site_perl/5.005/sun4-solaris
#	/usr/perl5/site_perl/5.005
#	.
#	testfunc in libtest2

use lib "libtest1";
use lib "libtest2";	#	uses the last one

#	We could also manipulate @INC by hand with push and/or unshift

use libtest;

foreach ( @INC ) {
	print "$_\n";
}

foreach ( %INC ) {
	print "$_\n";
}


#	Can't locate libtest.pm in @INC (@INC contains: /usr/perl5/5.00503/sun4-solaris /usr/perl5/5.00503 /usr/perl5/site_perl/5.005/sun4-solaris /usr/perl5/site_perl/5.005 .) at ./libtest.pl line 3.

&libtest::testfunc();
print "This print after running testfunc\n";


exit;

