#!/usr/bin/perl -w



my $var1 = "one";
my $var2 = "two";

my $num = "1";

#	print ${var${num}};

my $new = "var1";

print "$new\n";
print "${\$new}\n";
print "\${$new}\n";
print "$$new\n";






exit;


