#!/usr/bin/perl -w


print "$0\n";

#	this really runs ping, but ping thinks its name is myfakename
my $status = system  {"ping"} "myfakename", "sdc.unige.ch" ;				#	works
print "\$status = $status\n";

my $status = system  "ping isdc.unige.ch" ;				#	works
print "\$status = $status\n";

#	one could parse the output of the executed command in realtime with this
#	Ctrl-C break perl in this
open FAKEFILE, "ping  isdc.unige.ch |";
while (<FAKEFILE>) {
	print $_;
}

print "DONE\n\n";

exec  {"ping"} "myfakename", "sdc.unige.ch" ;				#	works

