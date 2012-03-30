#!/usr/local/bin/perl -w

use strict;
#use File::Basename;
#use POSIX;
use MP3::Tag;

my $dryrun;
my $filename = "";
my $FUNCNAME = "showmp3id3tags";
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
					."  --showall          -> default function\n"
					."  --movev1tov2       -> \n"
					."  --removev1         -> \n"
					."  --removev2         -> \n"
					."  --editv1           -> \n"
					."  --editv2           -> \n"
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
	#	nothing at this time your honor
}

exit unless ( $#ARGV >= 0 );
my $morethanone;

#	loop through all the rest after the first without a leading -
while ( $ARGV[0] ) {
	$filename = $ARGV[0];
	print "-------------------------------------------------------\n" if ( $morethanone );
	print "$filename ";

	my $mp3 = MP3::Tag->new($filename);
	$mp3->get_tags();										# read an existing tag
	if ( exists $mp3->{ID3v2} ) {
		print "has an ID3v2 tag\n";
		&RemoveID3v2Tag( $mp3 );
	} elsif ( exists $mp3->{ID3v1} ) {
		print "has an ID3v1 tag\n";
		&RemoveID3v1Tag( $mp3 );
	} else {
		print "does not have an ID3v1 or ID3v2 tag\n";
		$morethanone++;
		shift @ARGV;
		next;
	}

	$morethanone++;
	shift @ARGV;
}     # while options left on the command line

exit;

sub RemoveID3v1Tag {
	my ( $mp3 ) = @_;

	$mp3->{ID3v1}->remove_tag();
}

sub RemoveID3v2Tag {
	my ( $mp3 ) = @_;

	$mp3->{ID3v2}->remove_tag();
}

sub ShowID3v1Tags {
	my ( $mp3 ) = @_;

	# read some information from the tag
	my $id3v1 = $mp3->{ID3v1};  # $id3v1 is only a shortcut for $mp3->{ID3v1}
	#print "ID3v1 - " , $id3v1->title, "\n";

	#* Reading the tag

	print "  Title: " .$id3v1->title . "\n";
	print " Artist: " .$id3v1->artist . "\n";
	print "  Album: " .$id3v1->album . "\n";
	print "Comment: " .$id3v1->comment . "\n";
	print "   Year: " .$id3v1->year . "\n";
	print "  Genre: " .$id3v1->genre . "\n";
	print "  Track: " .$id3v1->track . "\n";

	# or at once
	#my @tagdata = $id3v1->all();
	#foreach my $tag (@tagdata) {
	#	print $tag;
	#}

	#* Changing / Writing the tag

	#$id3v1->comment("This is only a Test Tag");
	#$id3v1->title("testing");
	#$id3v1->artist("Artest");
	#$id3v1->album("Test it");
	#$id3v1->year("1965");
	#$id3v1->track("5");
	#$id3v1->genre("Blues");
	## or at once
	#$id3v1->all("song title","artist","album","1900","comment",10,"Ska");
	#$id3v1->write_tag();

	#* Removing the tag from the file

	#$id3v1->remove_tag();

}

sub ShowID3v2Tags {
	my ( $mp3 ) = @_;

	my $id3v2 = $mp3->{ID3v2};
	#$id3v2 = $mp3->new_tag("ID3v2");						# or create a new tag

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
	#my $newtitle = basename($filename);
	#$newtitle =~ s/(.mp3)$//;
	#$id3v2->change_frame("TIT2","$newtitle");
	#         $id3v2->remove_frame("TLAN");
	#$id3v2->write_tag();
	
	#$id3v2->remove_tag();									#       * Removing the whole tag
}


