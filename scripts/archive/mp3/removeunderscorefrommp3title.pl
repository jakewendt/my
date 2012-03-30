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
					."\n\n"
				; # closing semi-colon
				exit 0;
			}
		elsif ( /-v/ ) {
			print "Log_1  : Version : $FUNCNAME $FUNCVERSION\n";
			exit 0;
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

	$id3v2->write_tag() unless ( $dryrun );

	shift @ARGV;
	print "\n";
}     # while options left on the command line

exit;




