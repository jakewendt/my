#!/usr/bin/perl -w

$| = 1;


chomp ( my @trigger = `ls /isdc/integration/isdc_int/sw/dev/prod/opus/consssa/unit_test/opus_work/consssa/input//002400050010_spi.trigger*` );
print ( "Trigger +$trigger[0]+\n" );

my ( $trigger_done ) = ( $trigger[0] =~ /(.+)_(bad|processing)/ );
#my $trigger_done = $trigger[0];
#print ( "Done Trigger +$trigger_done+\n" );
#$trigger_done =~ s/^(.+)_processing/$1/ ;
print ( "Done Trigger +$trigger_done+\n" );









exit;


