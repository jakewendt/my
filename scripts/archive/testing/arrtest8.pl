#!/usr/bin/perl -w


my @arr = "ccc";

#if ( ( scalar(@arr) == 1 ) && ( $arr[0] =~ /ccc/ ) ) {
if ( ( @arr == 1 ) && ( $arr[0] =~ /ccc/ ) ) {	#	default is "scalar" in this context
	print "done\n";
}


