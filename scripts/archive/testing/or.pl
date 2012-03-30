#!/usr/bin/perl


# The or'ing isn't just on existance, but value as well.
#
#	False if does not exist, is undefined, equals "" or 0
#	Basically only true if exists with defined value other than "" or 0;
#

#my %h = ( 'val' => 'hash' );
#$h{'val'} = 'hash';
#my $val = 1;
#my $val = 0;
#my $val = "";
#my $val = " ";


print $h{'val'}||$val||'test',"\n";

my %n = (
	'val' => $h{'val'}||$val||'test'
);


print $n{'val'}."\n";
