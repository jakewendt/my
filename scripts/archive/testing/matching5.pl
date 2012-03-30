#!/usr/bin/perl -w

my $string = "# FILE: /nrt/tst_v1_systst_1/nrt_rev_2/nrt/ops_1/o
# KEYNAME: CREATOR

# EXTENSION:    1
CREATOR = 'ii_skyimage 4.8.3'  / Executable which created or modified this data
";

print "string before $string\n";

#$string =~ s/^.+CREATOR = '(.+)'.*$/$1/s;
#	or
( $string ) = ( $string =~ /CREATOR = '(.+)'/ );

print "string after $string\n";


