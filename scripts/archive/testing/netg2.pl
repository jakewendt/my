#! /bin/sh
eval '  exec perl -x $0 ${1+"$@"} '
#! perl -w

for ( $i = 0; $i < 5; print $i++."\n" ){}


