
package chomplib;

$| = 1;

sub chomptest {
	foreach ( @_ ) {
		chomp;		#	for some reason in some of my scripts, I'm not allowed to do this?????
		print "$_\n";
	}
}

