#!/usr/bin/perl -w

my $dir = $ARGV[0];

print "Checking dir $dir\n";
my @filelist = glob ( "$dir/*" );
#print @filelist;

if ( @filelist ) {
	print "Dir $dir is not empty\n";
}
else {
	print "Dir $dir is empty\n";
}

exit;


