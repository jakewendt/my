#!/usr/bin/perl

mkdir "Corrected";

@filelist=`/bin/ls DCP*`;

foreach ( @filelist )
{
	chomp;
	open( $_ );
	print "File: $_\n";

#	find ####:##:## ##:##:##
#	yyyy:mm:dd HH:MM:SS
#	HH+=6
#	if HH > 23 then dd++
#	s/00:01:00/02:09:21/g  $each > ./Corrected/$each
	close( $_ );
}

