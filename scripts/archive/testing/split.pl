#!/usr/bin/perl -w


my $line = "This +is a test +string for matching.";

my @words = split ('\s+\+',$line);

foreach ( @words ) {
	print "$_\n";
}

print "-----\n";

my $scwnum = "0123456789AB";
print "$scwnum\n";
$_ = $scwnum;
my @cre    = split(//);
print "@cre\n";
my $crev   = $cre[0].$cre[1].$cre[2].$cre[3];
print "$crev\n";



my $files = `find . -name p\\\*`;

print "$files\n";

print "------\n";

my @files = split "\n","$files";
print @files;

