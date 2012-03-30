#!/usr/bin/perl -w

$| = 1;

print "Before\n";

while (1) {
	print "In NO\n";
	print `tty` if ( `tty` );;
	sleep 1;
}

print "After\n";

print `tty`;











exit;


