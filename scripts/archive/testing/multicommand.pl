#!/usr/bin/perl -w

my $var = "test matching";

print "test" and print "OK" if ( $var =~ /match/ );

#	this doesn't seem to work if you use something like ISDCPipeline::PiplineStep(.....) and return;
#	I think that the pipelinestep doesn't return what perl is looking for to do the other command


exit;


