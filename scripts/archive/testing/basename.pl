#!/usr/bin/perl -w 

use File::Basename;



print &File::Basename::basename ( `pwd` )."\n";

exit;

