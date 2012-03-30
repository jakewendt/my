#!/usr/bin/perl -w


my $line = "Log_1  : Selection [MEMBER_VERSION < 0] (3 members.) File not created.";

#	Log_1  : Selection [MEMBER_VERSION < 0] (0 members.) File not created.

#	Log_1  : Selection [MEMBER_VERSION < 4] (3 members.) NumLog : 3
#	Log_0  : /isdc/integration/isdc_int/sw/dev/prod/opus/nrtscw/unit_test/outref/scw/0025/002500010010.000/intl_osm_gti.fits[INTL-GNRL-GTI,1,BINTABLE]
#	Log_0  : /isdc/integration/isdc_int/sw/dev/prod/opus/nrtscw/unit_test/outref/scw/0025/002500010010.000/intl_osm_gti.fits[INTL-GNRL-GTI,2,BINTABLE]
#	Log_0  : /isdc/integration/isdc_int/sw/dev/prod/opus/nrtscw/unit_test/outref/scw/0025/002500010010.000/intl_osm_gti.fits[INTL-GNRL-GTI,3,BINTABLE]


my $line2 = "/isdc/integration/isdc_int/sw/dev/prod/opus/nrtscw/unit_test/outref/scw/0025/002500010010.000/intl_osm_gti.fits[INTL-GNRL-GTI,2,BINTABLE]";

print "$line\n";


$line =~ /([\d+])\s+members/;
print $1 if (defined ($1));

print "OK\n"  if ( defined($1) and ( $1 > 0 ));

my $num = $line;

$num =~ s/^.*([\d+])\s+members.*$/$1/;
print "$num\n";


print "$line2\n";

$line2 =~ s/^(.*)\[.*$/$1/;

print "$line2\n";
my $test = "";
print "$line2\n" if ( defined ( $test ) );

exit;


