#!/usr/bin/perl -w

my $line = "one two three four";
my @words = split ( " ", $line );

print "@words\n";
print join("\n",@words),"\n";

my @test = ( "asdf", "asdf" );
if ( @test == 2 ){ 
	print "\@test = 2 : OK\n";
}
if ( $#test == 1 ){ 
	print "\$#test = 1 : OK\n";
}


exit;


