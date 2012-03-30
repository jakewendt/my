#!/usr/bin/perl -w


my $line = "Log_1   2004-06-08T13:19:14 dal_dump 1.0:    1";



print "Match : $1\n" if ( $line =~ /^\s*Log_1\s*.*dal_dump.*:\s*(\d+)\s*$/ );






exit;


