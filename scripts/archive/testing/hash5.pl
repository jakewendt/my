#!/usr/bin/perl -w

#	trying to gain access to the keys of a subhash if possible
#	or trying to make a hash from part of a hash


my %myhash;

#$myhash{A}{1} = "A.1";
#$myhash{A}{2} = "A.2";
#$myhash{A}{3} = "A.3";
#$myhash{B}{1} = "B.1";
#$myhash{B}{2} = "B.2";
#$myhash{B}{3} = "B.3";
$myhash{1234}{a} = "ccc";
$myhash{1235}{4} = "ccc";

print keys(%myhash)."\n";

if ( keys(%myhash) == 2 ) {
	print "there are 2 keys\n";
	print %myhash;
}


exit;



