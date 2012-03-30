#!/usr/bin/perl -w

@ARGV = glob "fred*.dat"; 
$^I = ".bak"; 
while (<>) { 
  s/Randall/Randal/g; 
  print; 
}

#	is the same as ...
#	perl -p -i.bak -w -e 's/Randall/Randal/g' fred*.dat
