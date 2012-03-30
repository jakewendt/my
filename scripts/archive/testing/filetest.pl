#!/usr/bin/perl -w


my $dir = "testdir";
my $file = "testfile";

print $dir."/".$file;
print "\n";
print "exists 1\n" if ( -r $dir."/".$file );


#	print ${dir}/${file};		#	can't do this (attempts to divide)
#	print "\n";
print "${dir}/${file}";
print "\n";
print "exists 2\n" if ( -r "${dir}/${file}" );

