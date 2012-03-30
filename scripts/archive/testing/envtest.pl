#!/usr/bin/perl -w


print "Before : $ENV{COMMONLOGFILE}\n\n";

$ENV{COMMONLOGFILE} = "+".$ENV{COMMONLOGFILE} unless ( $ENV{COMMONLOGFILE} =~ /^\+/ );

print "After  : $ENV{COMMONLOGFILE}\n\n";

print "pwd : ".`pwd`."\n\n";




exit;


