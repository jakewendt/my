#!/usr/bin/perl -w

$| = 1;

for ( my $i=1; $i<=100; $i++ ) {
	#print $i;
	printf ("%3d\r", $i);
	#printf ("%3d", $i);
	#for ( my $j=1; $j<=100000; $j++ ) { }
	sleep 1;
}

print "\n";










exit;


