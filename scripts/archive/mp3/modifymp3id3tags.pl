#!/usr/local/bin/perl -w

use strict;
use File::Basename;
use POSIX;
use MP3::Tag;


my $dryrun;
my $filename = "";
my $totaltracks = 0;
my $newartist = "";
my $newalbum = "";
my $numtracks;
my $special = 0;

my $FUNCNAME = "modifymp3tags";
my $FUNCVERSION = "1.0";

exit unless ( $#ARGV >= 0 );

#	print "$#ARGV\n";
#	loop through all parameters that begin with - until one doesn't have a leading - 
if ( defined ($ARGV[0]) ) {
	while ($_ = $ARGV[0], /^-.*/) {
		if ( /-h/ ) {
				print 
					"\n\n"
					."Usage:  $FUNCNAME  [options] file(s)\n"
					."\n"
					."  -v, --v, --version -> version number\n"
					."  -h, --h, --help    -> this help message\n"
					."  --dryrun           -> don't do anything\n"
					."  --numtracks        -> edit track nums based on position in list\n"
					."  --totaltracks      -> add total number of tracks only if using --numtracks as well\n"
					."  --album            -> album name\n"
					."  --artist           -> artist name\n"
					." Normal : 12 Common Bitch.mp3\n"
					."  --special #        -> use a special setup [1]\n"
					."  --special 1  : TRACK - TITLE - ALBUM.mp3\n"
					."  --special 2  : TRACK - TITLE - GARBAGE.mp3\n"
					."  --special 3  : GARBAGE-TRACK-TITLE.mp3\n"
					."  --special 4  : TRACK-TITLE.mp3\n"
					."  --special 5  : TRACK_TITLE.mp3\n"
					."  --special 6  : TRACK.T.I.T.L.E.mp3\n"
					."  --special 7  : TRACK - athens-TITLE.mp3\n"
					."  --special 8  : Ween-ZurichSwitzerland-11-27-97-CD#-TRACK-TITLE.mp3\n"
					."  --special 9  : Ween_9-28-97_More_SmokeTRACK-TITLE.mp3\n"
					."  --special 10 : JimmyWilsonGroup-TheSaint07_10_97-TRACK-TITLE.mp3a\n"
					."  --special 11 : TRACK - austin-TITLE.mp3\n"
					."  --special 12 : NashTRACK-TITLE.mp3\n"
					."  --special 13 : TRACK trenton 89 TITLE.mp3\n"
					."  --special 14 : vpro90-TRACK-TITLE.mp3\n"
					."  --special 15 : TRACK-Trenton_2_2_90-TITLE.mp3\n"
					."  --special 16 : 19- TRACK   TITLE.mp3\n"
					."  --special 17 : KennelClub1992-TRACK-TITLE.mp3\n"
					."  --special 18 : Chicago-20-Nov-1992-TRACK-TITLE.mp3\n"
					."  --special 19 : peel93 - TRACK - TITLE.mp3\n"
					."  --special 20 : JJJ-10_93-TRACK-TITLE.mp3\n"
					."  --special 21 : Philly-14-Oct-1994-TRACK.TITLE.mp3\n"
					."  --special 22 : TRACK_GARBAGE-TITLE.mp3\n"
					."  --special 23 : GARBAGE-TRACKTITLE.mp3\n"
					."  --special 24 : rrr_radio-4_18_95-TRACK-mongoloid-devo_cover(acoustic_aborted).mp3\n"
					."  --special 25 : bt-paris-2-12-92-TITLE.mp3\n"
					."  --special 26 : bt-gale-9-30-89-TITLE.mp3\n"
					."\n\n"
				; # closing semi-colon
				exit 0;
			}
		elsif ( /-v/ ) {
			print "Log_1  : Version : $FUNCNAME $FUNCVERSION\n";
			exit 0;
		}
		elsif ( /-num/) {
			$numtracks++;
		}
		elsif ( /-art/) {
			shift @ARGV;
			$newartist = $ARGV[0];
		}
		elsif ( /-alb/) {
			shift @ARGV;
			$newalbum = $ARGV[0];
		}
		elsif ( /-spe/) {
			shift @ARGV;
			$special = $ARGV[0];
		}
		elsif ( /-tot/) {
			shift @ARGV;
			$totaltracks = $ARGV[0];
		}
		elsif ( /-dry/) {
			$dryrun++;
		}
		else {  # all other cases
			print "ERROR: unrecognized option +$ARGV[0]+.  Aborting...\n";
			print "\n";
			exit 1;
		}
		shift @ARGV;
	}     # while options left on the command line
} else {
	
}

exit unless ( $#ARGV >= 0 );
my $track;

#	loop through all the rest after the first without a leading -
while ( $ARGV[0] ) {
	$filename = $ARGV[0];
	print "$filename\n";
	$track++;
	my $mp3 = MP3::Tag->new($filename);
	$mp3->get_tags();										# read an existing tag
	my $id3v2;
	$id3v2 = $mp3->{ID3v2} if exists $mp3->{ID3v2};

	$id3v2 = $mp3->new_tag("ID3v2") unless ( exists ( $mp3->{ID3v2} )  );

	my $frameIDs_hash = $id3v2->get_frame_ids('truename');		#	I don't know what 'truename' means

	foreach my $frame (keys %$frameIDs_hash) {				#	I think this only returns Tags that have values
		my ($name, @info) = $id3v2->get_frame($frame);
		for my $info (@info) {
			if (ref $info) {								#	I have no idea what this is for (Multilined comments, I believe)
				print "$name ($frame):\n";
				while(my ($key,$val)=each %$info) {
					print " * $key => $val\n";
				}
			} else {										#	the else always seems to be run
				print "$frame - $name: $info\n";
				#	My test output ....
				#	TRCK - 1: Track number/Position in set
				#	TPE1 - ween: Lead performer(s)/Soloist(s)
				#	TIT2 - AudioTrack 01: Title/songname/content description
				#	MCDI - HASH(0x835df8): Music CD identifier
				#	TALB - 10.12.96: Album/Movie/Show title
				#	TCON - Unknown: Content type

				#	My second test output...
				#	TRCK - 12/12: Track number/Position in set
				#	TCOM - Joni Mitchell: Composer
				#	TPOS - 1/1: Part of a set
				#	PIC - HASH(0x8c161c): Attached picture
				#	TIT2 - Fiddle and the Drum: Title/songname/content description
				#	TYER - 2004: Year
				#	TCON - Alternative & Punk: Content type
				#	TPE1 - A Perfect Circle: Lead performer(s)/Soloist(s)
				#	TENC - iTunes v4.7: Encoded by
				#	COMM - HASH(0x8c161c): Comments
				#	HASH(0x8c161c) (COMM):
				#	 * Language => eng
				#	 * Description => iTunes_CDDB_IDs
				#	 * Text => 12+CE1B7661693BB48DF3D86B912FE908A3+4710639
				#	TALB - eMOTIVe: Album/Movie/Show title
				#	Can't convert PIC to ID3v2.3
			}
		}
	}
	#       * Adding / Changing / Removing / Writing a tag
	#         $id3v2->add_frame("TIT2", "Title of the song");

	my $newtitle = basename($filename);
#	my ( $newtrack ) = ( $newtitle =~ /^(\d+)/ );
#	$newtrack = $track unless ( $newtrack );
	$newtitle =~ s/(.mp3)$//i;
	$newtitle =~ s/^([\d\-_\s]*)// unless ( $special );	#	== 1 or 2

	if ( $special == 1 ) {
		 #19 - puerto rican power-buenas tardes amigo - koln 1995-03-22.mp3
		( $track, $newtitle, $newalbum ) = split " - ", $newtitle;
		$newalbum = $id3v2->get_frame("TALB")." $newalbum";
	}
	elsif ( $special == 2 ) {
		#57 - Crowd - Talk.mp3
		( $track, $newtitle ) = split " - ", $newtitle;
	}
	elsif ( $special == 3 ) {
		#LBW-10-Stacey.mp3
		( my $nothing, $track, $newtitle ) = split "-", $newtitle;
	}
	elsif ( $special == 4 ) {
		#08-The Iron Whore.mp3
		( $track, $newtitle ) = split "-", $newtitle;
	}
	elsif ( $special == 5 ) {
		#08_The Iron Whore.mp3
		( $track, $newtitle ) = ( $newtitle =~ /^(\d+)_(.*)$/ );
	}
	elsif ( $special == 6 ) {
		#29.you.fucked.up.mp3
		( $track, $newtitle ) = ( $newtitle =~ /^(\d+)\.(.*)$/ );
		$newtitle =~ s/\./ /g;
	}
	elsif ( $special == 7 ) {
		#32 - athens-buenostardes.mp3
		( $track, $newtitle ) = ( $newtitle =~ /^(\d+) - athens-(.*)$/ );
	}
	elsif ( $special == 8 ) {
		#Ween-ZurichSwitzerland-11-27-97-CD2-11-ItsGonnaBe(Alright).mp3
		( $track, $newtitle ) = ( $newtitle =~ /^Ween-ZurichSwitzerland-11-27-97-CD\d-(\d+)-(.*)$/ );
	}
	elsif ( $special == 9 ) {
		#Ween_9-28-97_More_Smoke34-You_Fucked_Up_RepriseEND.mp3
		( $track, $newtitle ) = ( $newtitle =~ /^Ween_9-28-97_More_Smoke(\d+)-(.*)$/ );
	}
	elsif ( $special == 10 ) {
		#JimmyWilsonGroup-TheSaint07_10_97-TRACK-TITLE.mp3a\n"
		( $track, $newtitle ) = ( $newtitle =~ /^JimmyWilsonGroup-TheSaint07_10_97-(\d+)-(.*)$/ );
	}
	elsif ( $special == 11 ) {
		#TRACK - austin-TITLE.mp3\n"
		( $track, $newtitle ) = ( $newtitle =~ /^(\d+) - austin-(.*)$/ );
	}
	elsif ( $special == 12 ) {
		#NashTRACK-TITLE.mp3
		( $track, $newtitle ) = ( $newtitle =~ /^Nash(\d+)-(.*)$/ );
	}
	elsif ( $special == 13 ) {
		#TRACK trenton 89 TITLE.mp3\n"
		( $track, $newtitle ) = ( $newtitle =~ /^(\d+) trenton 89 (.*)$/ );
	}
	elsif ( $special == 14 ) {
		#vpro90-TRACK-TITLE.mp3
		( $track, $newtitle ) = ( $newtitle =~ /^vpro90-(\d+)-(.*)$/ );
	}
	elsif ( $special == 15 ) {
		# TRACK-Trenton_2_2_90-TITLE.mp3\n"
		( $track, $newtitle ) = ( $newtitle =~ /^(\d+)-Trenton_2_2_90-(.*)$/ );
	}
	elsif ( $special == 16 ) {
		#19- TRACK   TITLE.mp3\n"
		( $track, $newtitle ) = ( $newtitle =~ /^\d+-\s*(\d+)\s+(.*)$/ );
	}
	elsif ( $special == 17 ) {
		#KennelClub1992-TRACK-TITLE.mp3
		( $track, $newtitle ) = ( $newtitle =~ /^KennelClub1992-(\d+)-(.*)$/ );
	}
	elsif ( $special == 18 ) {
		# Chicago-20-Nov-1992-17-LMLYP.mp3
		( $track, $newtitle ) = ( $newtitle =~ /^Chicago-20-Nov-1992-(\d+)-(.*)$/ );
	}
	elsif ( $special == 19 ) {
		# peel93 - 01 - What Deaner Was Talking About.mp3
		( $track, $newtitle ) = ( $newtitle =~ /^peel93 - (\d+) - (.*)$/ );
	}
	elsif ( $special == 20 ) {
		# JJJ-10_93-TRACK-TITLE.mp3\n"
		( $track, $newtitle ) = ( $newtitle =~ /^JJJ-10_93-(\d+)-(.*)$/ );
	}
	elsif ( $special == 21 ) {
		#Philly-14-Oct-1994-TRACK.TITLE.mp3\n"
		( $track, $newtitle ) = ( $newtitle =~ /^Philly-14-Oct-1994-(\d+)\.(.*)$/ );
	}
	elsif ( $special == 22 ) {
		#TRACK_GARBAGE-TITLE.mp3\n"
		( $track, $newtitle ) = ( $newtitle =~ /^(\d+)_.*-(.*)$/ );
	}
	elsif ( $special == 23 ) {
		#GARBAGE-TRACKTITLE.mp3\n"
		( $track, $newtitle ) = ( $newtitle =~ /^.*-(\d+)(.+)$/ );
	}
	elsif ( $special == 24 ) {
		#rrr_radio-4_18_95-TRACK-mongoloid-devo_cover(acoustic_aborted).mp3\n"
		( $track, $newtitle ) = ( $newtitle =~ /^rrr_radio-4_18_95-(\d+)-(.+)$/ );
	}
	elsif ( $special == 25 ) {
		#bt-paris-2-12-92-what's for breakfast.mp3"
		( $newtitle ) = ( $newtitle =~ /^bt-paris-2-12-92-(.+)$/ );
	}
	elsif ( $special == 26 ) {
		#bt-gale-9-30-89-crashburn-miss you.mp3
		( $newtitle ) = ( $newtitle =~ /^bt-gale-9-30-89-(.+)$/ );
	}



	my $captitle;
	$newtitle =~ s/_/ /g;
	$newtitle =~ s/-/ /g;
	foreach my $word ( split " ", $newtitle ) {
		$captitle .= ucfirst ( $word );
		$captitle .= " ";
	}
	$captitle =~ s/\s+$//;
	$newtitle = $captitle;

	$track =~ s/^\s*(\d+).*$/$1/;

	$id3v2->change_frame("TIT2","$newtitle")
		or $id3v2->add_frame("TIT2","$newtitle");

	$id3v2->change_frame("TALB","$newalbum")
		or $id3v2->add_frame("TALB","$newalbum") if ( "$newalbum" );

	$id3v2->change_frame("TPE1","$newartist")
		or $id3v2->add_frame("TPE1","$newartist") if ( "$newartist" );

	$id3v2->change_frame("TRCK","$track/$totaltracks")
		or $id3v2->add_frame("TRCK","$track/$totaltracks") if ( $numtracks );
	
	#         $id3v2->remove_frame("TLAN");
	$id3v2->write_tag() unless ( $dryrun );
	
	#$id3v2->remove_tag();									#       * Removing the whole tag

	shift @ARGV;
	print "\n";
}     # while options left on the command line

exit;




