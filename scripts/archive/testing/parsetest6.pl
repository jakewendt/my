#!/usr/bin/perl -w

use File::Basename;



#my $dol = "/asdc/jmx2_gti.fits[JMX2-GNRL-GTI]";
my $dol = "asdc/jmx2_gti.fits[JMX2-GNRL-GTI]";
#my $dol = "/asdc/jmx2_gti.fits";
print "dol      :  $dol\n";

#( my $filename = $dol ) =~ s/^[\w\d\.]+(\[.*)$//;
#my $filename = $dol;
#$filename =~ s/[\w\d\.\/]+(\[.+)$//;

#my ( $filename ) = ( $dol =~ /^([\w\d\.\/]+)\[/ );

my ($filename,$path,$ext) = &File::Basename::fileparse( $dol, '\[.*');

print "dol      :  -$dol-\n";
print "filename :  -$path$filename-\n";

my $newfilename = &File::Basename::basename ( $dol );
my $newdirname  = &File::Basename::dirname  ( $dol );

print "new file name : $newfilename\n";
print "new dir  name : $newdirname\n";


print "---------------------\n";
$dol =~ s/\[.*$//;
print "dol      :  -$dol-\n";


exit;


