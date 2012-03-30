#!/usr/bin/perl -w



$_ = "JMX2";
my ($jemxnum) = ( /\w+(\d)/ );
print "$jemxnum\n\n";


my $inst = "JMX1";
($jemxnum) = ( $inst =~ /\w+(\d)/ );
print "$jemxnum\n\n";


my $line = "Log_1  : Input Time(REVNUM): 54 Output Time(IJD): Boundary 1177.92177296296313215862 1180.91137944444449203729";


print "$line\n";


my ($first, $second) =  ( $line =~ /(\d\.\d)/g );
print "1: ($first, $second)\n";

($first) =  ( $line =~ /(\d\.\d)/ );
print "2: ($first)\n";

$first =  ( $line =~ /(\d\.\d)/ );
print "3: $first\n";

print "4: ";
print ( $line =~ /(\d\.\d)/ );
print "\n";

print "5: ";
print `uptime`;
my ($one,$five,$fifteen) = (`uptime` =~ /(\d+\.\d+)/g);
print "6: ($one,$five,$fifteen)\n";

($first, $second) =  ( $line =~ /(\d{4,5}\.\d)/g );
print "7: ($first, $second)\n";

($first = $line ) =~ s/^.*(\d\.\d).*$/$1/;
print "8:  $first\n";

my $temp = $line;
print "$temp\n";
$temp =~ s/^.*(\d\.\d).*$/$1/;
print "$temp\n";


print "$line\n";

print "--------------\n\n";

my $OSF_DATASET = "ssj2_002400050010";
my ( $scwid ) = ( $OSF_DATASET =~ /^ss\w{2}_(\d{12})$/ );
print "$scwid\n";
my ( $revno ) = ( $scwid =~ /^(\d{4})/ );
print "$revno\n\n";

my $scwid = "001700020010";
my $scwdir = "obs/saib_unit_test.000/scw/${scwid}.001" ;
print "$scwdir\n";
( $scwid ) = ( $scwdir =~ /(${scwid}\.\d{3})$/ );
print "$scwid\n";


print "--------------\n\n";

$_ = "Log_1  : Input Time(REVNUM): 54 Output Time(IJD): Boundary 1177.92177296296313215862 1180.91137944444449203729";
($first ) =~ s/^.*(\d\.\d).*$/$1/;
print " 9:  $first\n";
print "10:  $_\n";


exit;

#	
#	2
#	
#	1
#	
#	Log_1  : Input Time(REVNUM): 54 Output Time(IJD): Boundary 1177.92177296296313215862 1180.91137944444449203729
#	1: (7.9, 0.9)
#	2: (7.9)
#	3: 1
#	4: 7.9
#	5:   3:28pm  up 160 day(s),  4:21,  8 users,  load average: 2.61, 2.01, 2.08
#	6: (2.61,2.01,2.08)
#	7: (1177.9, 1180.9)
#	8:  0.9
#	Log_1  : Input Time(REVNUM): 54 Output Time(IJD): Boundary 1177.92177296296313215862 1180.91137944444449203729
#	0.9
#	Log_1  : Input Time(REVNUM): 54 Output Time(IJD): Boundary 1177.92177296296313215862 1180.91137944444449203729
#	--------------
#	
#	002400050010
#	0024
#
#	obs/saib_unit_test.000/scw/001700020010.001
#	001700020010.001
#	--------------
#	
#	 9:  0.9
#	10:  Log_1  : Input Time(REVNUM): 54 Output Time(IJD): Boundary 1177.92177296296313215862 1180.91137944444449203729
