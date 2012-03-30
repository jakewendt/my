#!/usr/bin/perl -w

#my $file = "/reproc/run/pipelines/cons/consssa/scws_consssa_test.triggers";
#my $file = "/reproc/run/pipelines/cons/consssa/scws_crab.triggers";
my $file = "/reproc/run/pipelines/cons/consssa/scws_plane.triggers";

#	057400120021_isgri.trigger
#	057400130010_isgri.trigger
#	057400130021_isgri.trigger
#	057400140010_isgri.trigger

open FILE, "< $file";
open YES, "> processed.yes";
open NO , "> processed.no";
#open TAR, "> processed.tar";
#print TAR "tar cvf - ";
open INP, "> processed.input";
while (<FILE>) {
	my ( $scw ) = split /_/;
	my ( $revno ) = ( $scw =~ /^(.{4})/ );
#	print "$revno\n";
#	print "$scw\n";
	if ( -e "/reproc/cons/ops_sa/obs_isgri/$revno.000/ssii_$scw" ) {
		print "$scw exists\n";
		print YES "$scw\n";
		print INP "touch ${scw}_isgri.trigger\n";
		#print TAR "\\\n\t$revno.000/ssii_$scw ";
	} else {
		print "$scw DOES NOT EXIST\n";
		print NO "$scw\n";
	}
}
#print TAR "\\\n\t | gzip > /scratch/ops_ssa/scw_select.tar.gz\n";
close FILE;
close INP;
#close TAR;
close YES;
close NO;

