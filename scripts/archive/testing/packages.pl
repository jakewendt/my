#!/usr/bin/perl -w

use package1;	#	contains &mytestroutine;
use package2;

print "$pkg1\n";

foreach ( keys(%myhash) ) {

	print "$_ - $myhash{$_}\n";

}
$ENV{PROCESS_NAME} = "cssscw";

#&mytestroutine;
&mytestroutine2;


exit;



