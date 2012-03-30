#!/bin/sh
if [ -r myrcfile ] ; then  . myrcfile ; fi
eval 'exec perl -x $0 ${1+"$@"}'
#!perl

print "$ENV{TESTKEY}\n";
