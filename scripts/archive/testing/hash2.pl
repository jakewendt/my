#!/usr/bin/perl -w

#	trying to gain access to the keys of a subhash if possible
#	or trying to make a hash from part of a hash


my %myhash;

$myhash{A}{1} = "A.1";
$myhash{A}{2} = "A.2";
$myhash{A}{3} = "A.3";
$myhash{B}{1} = "B.1";
$myhash{B}{2} = "B.2";
$myhash{B}{3} = "B.3";

foreach $one ( keys(%myhash) ) {
	print "$one";						#	A
	print " - $myhash{$one}";		#	HASH(0x2c208)
	print " - %myhash{$one}";		#	%myhash{A}

#	my %mytemp = ( %myhash{$one} );		#	doesn't work
#	my %mytemp = ( %{myhash{$one}} );	#	doesn't work

	print "\n";
	my %mytemp = ( %{$myhash{$one}} );	#	THIS IS THE KEY!
	foreach $two ( keys ( %mytemp ) ) {
		print "$one $two = $mytemp{$two}\n";
	}
	print "\n";
}



exit;



