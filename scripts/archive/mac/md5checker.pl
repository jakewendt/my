#!/bin/perl -w

#		this script appears to be pointless
#		use md5sum -c somefile.md5

use strict;

my $filename;
my $md5ref;

#print "DEBUG-1\n";
while (<>) {
	#print "DEBUG-1\n";
	chomp;
	#print "DEBUG-2\n";
	($md5ref) = ( /([\w\d]{32})/ );
	#print "DEBUG-3\n";
	($filename = $_ ) =~ s/$md5ref// ;
	#print "DEBUG-4\n";
	$filename =~ s/\*//;
	#print "DEBUG-5\n";
	$filename =~ s/^\s*//;
	#print "DEBUG-6\n";

#	$filename =~ s/\s*$//;	#	some files may have Ctrl-M

#	The next line won't look right when this file is cat'd
#	$filename =~ s/$//;	#	some files may have Ctrl-M

#	print "$_\n";
#	print "$md5ref\n";
#	print "$filename--\n";

	print "$filename";
	if ( -e "$filename" ) {
		print " : $md5ref";
		my ($md5check) = ( `md5 $filename` =~ /([\w\d]{32})/ );
		print " : $md5check";
		if ( $md5check eq $md5ref ) {
			print " : MATCH\n";
		} else {
			print " : FAIL\n";
		}
	} else {
		print " not readable!!\n";
	}

#	print "$_\n";
#	print "$md5ref\n";
#	print "$md5check\n";
#	print "$filename--\n";

}



exit;

