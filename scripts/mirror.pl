#!/bin/sh
eval 'exec perl -x $0 ${1+"$@"}'
#!perl -w

use File::Basename;

my $drive  = "/Volumes/LaCie328";
my $backup = "/Volumes/LaCie328B";
my $temp   = "";	#"Jake/personal stuff";	#	can be used if don't want to mirror the whole drive
#	my $temp   = "Jake/Backups/iMacG5";		#	can be used if don't want to mirror the whole drive
#	my $temp   = "Jake/personal stuff";		#	can be used if don't want to mirror the whole drive

foreach my $dir ( $drive, $backup ) {
#	print glob $dir;
#	unless ( glob $dir ) {
	unless ( `ls -d $dir` ) {
		print "$dir doesn't exist\n";
		exit;
	} else {
		print "$dir exists\n";
	}
}


my $excludes = " --exclude=.Trashes --exclude=\"Temporary Items\" --exclude=NotMirrored ";
$excludes .= " --exclude=.VolumeIcon.icns --exclude=TheVolumeSettingsFolder ";

#$excludes .= " --exclude=Backups";
$excludes .= " --exclude=KeepOut";
$excludes .= " --exclude=.Spotlight-V100";
#$excludes .= " --exclude=CouldTrash";
#	$excludes .= " --exclude=Acquisition ";
#	$excludes .= " --exclude=Jake/Backups/rsyncbackup";
#	$excludes .= " --exclude=Music";
#	."--exclude=TheVolumeSettingsFolder "
#	."--exclude=.VolumeIcon.icns --exclude=Trash --exclude=\"Icon\?\" "
#	."--exclude=\"Desktop DB\" --exclude=\"Desktop DF\"";

print "Creating rsync --dry-run output.\n";

my $command = "/usr/bin/rsync -avz --dry-run --delete $excludes \"$drive/$temp/\" \"$backup/$temp/\"";
print "executing: $command\n";
my ($retval, @results) = `$command`;

#	exit;

my %mycopies = ();
my %mydeletes = ();

print "Parsing rsync --dry-run output.\n";

foreach ( @results ) {
	chomp;								#	yummy
	next if ( /building file list/ );
	next if ( /deleting directory / );
	next if ( /^wrote.*bytes\/sec$/ );	#	rsync's output
	next if ( /^total size is/ );		#	rsync's output
	next if ( /^\s*$/ );
	next if ( /DS_Store/ ); 			#	too many of em

	#	I am making the bad assumption that the same filename will
	#	not be used in different directories.
	($mydeletes{basename($_)} = $_ ) =~ s/^deleting // if ( /^deleting / );
	$mycopies{basename($_)}  = $_ unless ( /^deleting / );
}

print "Examining rsync --dry-run output.\n";

foreach $filen ( keys (%mydeletes) ) {
	print "\n$mydeletes{$filen} set to delete";
	
	if ( exists $mycopies{$filen} ) {
		print " AND found in copy hash\n";
		my ($retval, @results) = `diff \"$backup/$temp/$mydeletes{$filen}\" \"$drive/$temp/$mycopies{$filen}\"`;
		if ( $retval ) {
			print "diff says files are different anyway so will delete and copy\n";
			print "$retval";
		} else {
			my $newdir = "$backup/".dirname("$temp/$mycopies{$filen}");

			print "diff says files are the same so I'm gonna move the file from \n"
				."$backup/$temp/$mydeletes{$filen} \nto $newdir/\n";
			unless ( -d "${newdir}" ) {
				print "Must make ${newdir}\n";
				`mkdir -p \"${newdir}\"` unless (-d $newdir);
				die   "Could not mkdir -p $newdir" if ( $? );
			}
			print `mv \"$backup/$temp/$mydeletes{$filen}\" \"$newdir/\"`;
		}
	} else {
		print "\nNo match found to copy so will be deleted\n";
	}
}

print "\nRunning rsync now.\n\n";

#exec "time /usr/bin/rsync -avz --progress $excludes \"$drive/$temp/\" \"$backup/$temp/\"";

exec "time /usr/bin/rsync -avz --progress --extended-attributes $excludes \"$drive/$temp/\" \"$backup/$temp/\"";
#exec "time /usr/bin/rsync -avz --progress $excludes \"$drive/$temp/\" \"$backup/$temp/\"";
#exec "time /usr/bin/rsync -avz --delete --progress $excludes \"$drive/$temp/\" \"$backup/$temp/\"";

exit;
#	last line
