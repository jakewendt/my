#!/usr/bin/perl -w

print "Glob test 1\n";

foreach ( glob ("$ENV{OPUS_WORK}/*") ) {
	chomp;
	s/.*\///;
	print "$_\n";
}

print "\n\n";
print "Glob test 2\n";
`mkdir globtest1`;
print glob ( "globtest*" );
print "\n\n";

print "Glob test 3\n";
my $file = "IDONTEXIST";
print "Look for $file\n";
my @matches = glob ( "$file" );
print "Found @matches\n\n\n";

print "Glob test 4\n";
print "Look for $file*\n";
@matches = glob ( "$file*" );
print "Found @matches\n\n\n";

$file = "matching.pl matching1.pl matching2.pl";
print "Glob test 5\n";
print "Look for $file\n";
@matches = glob ( "$file" );
print "Found \n";
foreach ( @matches ) {
	print "$_\n";
}
print "\n";

print "Glob test 6\n";
print "Look for $file\n";
@matches = glob ( "$file" );
print "result : @matches\n";




print "\n";
exit;


