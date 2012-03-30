#!/usr/bin/perl -w

#	use Date::Calc qw(Delta_DHMS);

foreach ( `/bin/ls -d $ENV{REP_BASE_PROD}/scw/0070/0*` ) {
	chomp;
#	print "$_\n";

#	-----   2004-09-03T08:18:34:  STEP ScW Fin (CONS) - STARTING on host anaB5
	my ($sy,$sm,$sd,$sh,$smi,$ss) = ( `grep "STEP ScW Fin (CONS) - STARTING on host" $_/0*_scw.txt` =~ /(\d+)-(\d+)-(\d+)T(\d+):(\d+):(\d+)/ );
#	print "($sy,$sm,$sd,$sh,$smi,$ss)\n";

#	-----   Execution time:  77 seconds (approximate real elapsed time) for dp_average
	my ($dptime) = ( `grep "Execution time" $_/0*_scw.txt | grep dp_average` =~ /([\d]+) seconds/ );
#	print "$dptime\n";

#	-----   2004-09-03T08:20:11:  STEP ScW Fin (CONS) swfin - write protect all and trigger archive ingest
	my ($ey,$em,$ed,$eh,$emi,$es) = ( `grep "STEP ScW Fin (CONS) swfin - write protect all and trigger archive " $_/0*_scw.txt` =~ /(\d+)-(\d+)-(\d+)T(\d+):(\d+):(\d+)/ );
#	print "($ey,$em,$ed,$eh,$emi,$es)\n";


#	print "Fin Runtime : ".Delta_DHMS( ($ey,$em,$ed,$eh,$emi,$es), ($sy,$sm,$sd,$sh,$smi,$ss) )."\n";

#	my $dh  = $eh-$sh;
#	my $dmi = $emi-$smi;
#	my $ds  = $es-$ss;
#
#	print "Fin Runtime : $dh:$dmi:$ds\n";

	my $finstart = $ss + (60* $smi) + ( 3600 * $sh);
	my $finend   = $es + (60* $emi) + ( 3600 * $eh);
	my $finsecs = $finend - $finstart;
#	print "Fin Runtime : $finsecs\n";

	my $perdp = $dptime / $finsecs;

	print "$_\t$finsecs\t$dptime\t$perdp\n";


}



exit;



