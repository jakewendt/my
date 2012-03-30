#!/usr/bin/perl -w

my $c;
my $email;
open MAB, $ARGV[0];
while ( read(MAB,$c,1) ) {
	if ( $c =~ /\w|\d|\.|\@|\+|\-/ ) {
		$email .= $c;
	} else {
		print "$email\n" if ( $email =~ /.+\@.+\..+/ );
		$email = "";
	}
}
close MAB;
