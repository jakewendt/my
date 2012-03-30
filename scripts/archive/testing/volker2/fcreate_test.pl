#! /bin/sh
eval '  exec perl -x $0 ${1+"$@"} '
#! perl -s


open FILE, "| fcreate cdfile=output.cdf outfile=new.fits datafile=-";



close FILE;
