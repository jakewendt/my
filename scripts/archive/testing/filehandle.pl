#!/usr/bin/perl -w


print "Test out 1\n";

open LOG, "> filehandle.log";

print "Test out 2\n";

select LOG;
print "Test out 3\n";

select STDOUT;
print "Test out 4\n";

select LOG;
print "Test out 5\n";

print LOG    "Test out 6\n";
print STDOUT "Test out 7\n";

&dprint ( "Test out 8\n" );

close LOG;


exit;

sub dprint {
	print        "@_";
	print STDOUT "@_";
}

