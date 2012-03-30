#!/usr/bin/perl


#`fdump infile=$REP_BASE_PROD/idx/scw/GNRL-SCWG-GRP-IDX.fits outfile=STDOUT columns=MEMBER_LOCATION rows=- prhead=n prdata=y showcol=n showunit=n showrow=n showscale=n page=n pagewidth=256 | sed \"s/\/swg.fits//\" | sed \"s/\.\.\/\.\.\/scw\///\" > rsynclist`;

open FDUMP, "fdump infile=$ENV{REP_BASE_PROD}/idx/scw/GNRL-SCWG-GRP-IDX.fits outfile=STDOUT columns=MEMBER_LOCATION rows=- prhead=n prdata=y showcol=n showunit=n showrow=n showscale=n page=n pagewidth=256 | ";
open INCL, "> include";
open EXCL, "> exclude";

print EXCL "idx.rev1\n";
print EXCL "aux/org.bck_*\n";
print EXCL "aux/adp.bck_*\n";
print EXCL "aux\n";
print EXCL "idx/ic\n";
print EXCL "idx/obs\n";
print EXCL "ic\n";
print EXCL "cleanup\n";
print EXCL "obs\n";
print EXCL "scw/*\n";
print EXCL "scw/*/*\n";

while (<FDUMP>) {
	next unless ( /swg.fits/ );
	chomp;
	s/\/swg.fits//;
	s/\.\.\/\.\.\///;
	print INCL /^(scw\/....)/,"\n";		#	scw/0601
	print INCL /^(scw\/....)/,"/rev.000\n";#	scw/0601/rev.000
	print INCL "$_\n";						#	scw/0601/060100260010.000
	print INCL "$_/*fits*\n";				#	scw/0601/060100260010.000/*
	print INCL "$_/*alert\n";				#	scw/0601/060100260010.000/*
	print INCL "$_/*txt\n";					#	scw/0601/060100260010.000/*
	# # # # # # # # # # # # # # # # # # # 
	print EXCL "$_/raw\n";					#	scw/0601/060100260010.000/raw
	print EXCL "$_/raw/*\n";				#	scw/0601/060100260010.000/raw/*
	print EXCL "$_/swg_raw.fits\n";		#	scw/0601/060100260010.000/swg_raw.fits	#	doesn't work <--------<<<<
	last;
}
close FDUMP;
close INCL;
close EXCL;

die "include creation failed!:" unless ( -e "include" );
die "exclude creation failed!:" unless ( -e "exclude" );

#       -a = -rlptgoD
#       g - groups have become a problem so I'm ignorin em
#       t - times have become a problem so I'm ignorin em
#       D - devices are pointless here so I'm ignorin em
#       r - recursive
#       l - links
#       p - permissions
#       o - owner
#       v - verbose
#       z - compression
#       c - checksum

#	THE ORDER OF INCLUDE-FROM AND EXCLUDE-FROM ARE IMPORTANT!
#system ( "rsync -avz --include-from=include --exclude-from=exclude --delete-excluded /isdc/nrt/ops_1/ /isdc/pvphase/nrt/ops_2/" );
system ( "rsync -rlovz --include-from=include --exclude-from=exclude --delete-excluded /isdc/nrt/ops_1/ /isdc/pvphase/nrt/ops_2/" );
#system ( "rsync -rlvz --dry-run --include-from=include --exclude-from=exclude /isdc/nrt/ops_1/ /isdc/pvphase/nrt/ops_1/" );
#system ( "rsync -rlptoDvz --dry-run --include-from=include --exclude-from=exclude --delete-excluded /isdc/nrt/ops_1/ /isdc/pvphase/nrt/ops_1/" );
#system ( "rsync -avz --dry-run --include-from=include --exclude=\* --delete-excluded /isdc/nrt/ops_1/scw/ /isdc/pvphase/nrt/ops_1/scw/" );
#system ( "rsync -avz --dry-run --include-from=rsynclist --exclude=\* --delete-excluded /isdc/nrt/ops_1/scw/ /isdc/pvphase/nrt/ops_2/scw/" );

#unlink "include";
#unlink "exclude";

