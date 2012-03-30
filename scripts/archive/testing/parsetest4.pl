#!/usr/bin/perl -w



my $stamp = "2002-12-27T04:33:24.000";
print "Before  :  $stamp\n";

$stamp =~ s/^.*(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})\.\d{3}.*$/$1$2$3$4$5$6/;
print "After   :  $stamp\n";



exit;


