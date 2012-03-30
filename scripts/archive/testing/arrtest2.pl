#!/usr/bin/perl -w

my @vars = `/bin/ls -1`;

for ( my $i = 0; $i <= $#vars-2; $i+=3){
	print "$vars[$i]";
	print "$vars[$i+1]";
	print "$vars[$i+2]";
	print "\n";
}

exit;


