#!/usr/bin/perl -w


my $dir  = "linktestdir";
my $file = "linkfile";
my $link = "linktestlink";

`mkdir $dir`;
print "Made $dir\n" if ( -d $dir );

symlink $dir, $link;
print "Link is dir \n"  if ( -d $link );
print "Link exists \n"  if ( -e $link );
print "Link is file \n" if ( -f $link );
print "Link is link \n" if ( -l $link );

`rmdir $dir`;
print "Removed $dir\n" if ( ! -d $dir );

print "Link is dir \n"  if ( -d $link );
print "Link exists \n"  if ( -e $link );
print "Link is file \n" if ( -f $link );
print "Link is link \n" if ( -l $link );

unlink $link;
print "Removed $link\n" if ( ! -e $link );

print "Link is dir \n"  if ( -d $link );
print "Link exists \n"  if ( -e $link );
print "Link is file \n" if ( -f $link );
print "Link is link \n" if ( -l $link );

print "-- testing file now\n";


`touch $file`;
print "Made $file\n" if ( -f $file );

symlink $file, $link;
print "Link is dir \n"  if ( -d $link );
print "Link exists \n"  if ( -e $link );
print "Link is file \n" if ( -f $link );
print "Link is link \n" if ( -l $link );

`rm $file`;
print "Removed $file\n" if ( ! -f $file );

print "Link is dir \n"  if ( -d $link );
print "Link exists \n"  if ( -e $link );
print "Link is file \n" if ( -f $link );
print "Link is link \n" if ( -l $link );

unlink $link;
print "Removed $link\n" if ( ! -e $link );

print "Link is dir \n"  if ( -d $link );
print "Link exists \n"  if ( -e $link );
print "Link is file \n" if ( -f $link );
print "Link is link \n" if ( -l $link );

