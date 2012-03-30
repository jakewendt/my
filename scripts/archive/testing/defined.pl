#!/usr/bin/perl -w


#my ($key,$value) = split('=', "--dataset=0" );

#$ARGV[0] = "--dataset=0" unless ( "$ARGV[0]" );
$ARGV[0] = "--dataset" unless ( "$ARGV[0]" );

my ($key,$value) = split('=', "$ARGV[0]" );

$key =~ s/^--//;
if ( defined ( $value ) )  {              #  FIX 060208 - What if you WANT the value to be 0?
	print "$value\n";
} else {
	print "1\n";
}


exit;


