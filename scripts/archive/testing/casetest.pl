#!/usr/bin/perl -w


my $original = "Fucked up TexT";
my $upper = uc ( $original );
my $lower = lc ( $original );
print "$original\n$upper\n$lower\n";

#	or
$upper = "";
$lower = "";
( $upper = $original ) =~ tr/a-z/A-Z/;
( $lower = $original ) =~ tr/A-Z/a-z/;

#	These also work
#( my $upper = $original ) =~ tr/a-z/A-Z/;
#( my $lower = $original ) =~ tr/A-Z/a-z/;

print "$original\n$upper\n$lower\n";


exit;


