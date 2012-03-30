#!/usr/bin/perl -w -I /isdc/integration/isdc_int/sw/nrt_sw/prod/opus/pipeline_lib/


my @myarray = &testwantarray;

my $myscalar = &testwantarray;

print "array : @myarray\n\n";

print "scalar: $myscalar\n\n";


exit;


sub testwantarray {

	return (1,2,3) if wantarray;

	return 1 unless wantarray;

}

