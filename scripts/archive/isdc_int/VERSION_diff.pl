#! /bin/sh
eval '  exec perl -x $0 ${1+"$@"} '
#!/usr/bin/perl 
=start
exit; 
__END__
=cut
# -----------------------------------------------------------------------------
# Name:     VERSION_diff.pl
# Purpose:  To see the differences in two ISDC VERSION files.
# Date:     29 Sep 2003
# Author:   Mark Gaber
# Version:  0.03
#
# Revisions: 
# 
# 2003-10-01 0.03 Mark Gaber
# - When a component is absent in one of the files, a "---" placeholder appears
# making it obvious that there is no version number for this component.
#
# 2003-10-01 0.02 Mark Gaber
# - The state (diff, uniq, same) is now the first column of the output.
#
# 2003-09-29 0.01 Mark Gaber
# - Initial creation.
#------------------------------------------------------------------------------

  use File::Basename;

#------------------------------------------------------------------------------
# Initializations
#------------------------------------------------------------------------------
  $FUNCNAME    = basename($0);
  $FUNCVERSION = 0.03;

  $STR_EMPTY = "---";
  
  $DS{DIFFERENT}{str} = "different";
  $DS{UNIQUE}   {str} = "unique   ";
  $DS{SAME}     {str} = "same     ";
# $DS{SAME}     {str} = "";

  $DS{DIFFERENT}{order} = 2;
  $DS{UNIQUE}   {order} = 1;
  $DS{SAME}     {order} = 0;

#------------------------------------------------------------------------------
# Command line argument processing.
#------------------------------------------------------------------------------
  while ($_ = $ARGV[0], /^-.*/) {

    if ($_ eq "-h"     ||
           $_ eq "--h"    ||
           $_ eq "--help") {
      print 
      "\n\n"
     ."Usage:  VERSION_diff.pl  file1  file2\n"
     ."\n"
     ."Two ISDC version files are expected.  The component version number\n"
     ."differences are shown in the following order: different versions,\n"
     ."unique components, same versions.  Within these three categories\n"
     ."the components are listed in alphabetical order.\n"
     ."\n"
     ."Comments in the version files are ignored as are the fields beyond\n"
     ."the component and its version.  Adhering to Perl style, lines in the\n"
     ."VERSION file that follow __END__ are ignored.\n"
     ."\n\n"
     ; # closing semi-colon

      exit 0;
    }

    elsif ($_ eq "-v"        ||
           $_ eq "--v"       ||
           $_ eq "--version") {
      print "Log_1  : Version : $FUNCNAME $FUNCVERSION\n";
      exit 0;
    }

    else {  # all other cases
      print "ERROR: unrecognized option +$ARGV[0]+.  Aborting...\n";
      print "\n";
      exit 1;
    }
    shift @ARGV;
  }     # while options left on the command line


  if ($#ARGV != 1) {
    print "\n" 
         ."$FUNCNAME ERROR: Expecting two arguments for VERSION files to \n"
         ." compare.  Aborting... \n\n";
    exit 2;
  }

  $file1=$ARGV[0];
  $file2=$ARGV[1];

  if ((! -f $file1) || (! -f $file2)) {
    print "\n";
    if (! -f $file1) {
      print "ERROR: file1 not found: + $file1 +\n";
    }
    if (! -f $file2) {
      print "ERROR: file2 not found: + $file2 +\n";
    }
    print "  Aborting...\n";
    print "\n";
    exit 2;
  }

#------------------------------------------------------------------------------
# Populating the hash 
#------------------------------------------------------------------------------
  &readFile($file1, version1);
  &readFile($file2, version2);
  &writeCompVersions;

  exit 0;


#------------------------------------------------------------------------------
# Function
#------------------------------------------------------------------------------
sub readFile {

  local $file    = $_[0];
  local $version = $_[1];

  open(FILE,"<$file") or 
    &die("Could not open file + $file +",(caller(0))[3]);

  while (<FILE>){
    $line = $_;

    last if ($line eq "__END__\n");      # Anything past __END__ is ignored.
    next if (index($line,"#") == 0);     # ignore comments
    next if (m/^\s*\n$/);                # skip {0,n} whitespace lines

    @words = split(' ',$line);
    $compName = @words[0];
    $comp{$compName}{$version} = @words[1];
  }

  close FILE;
}

#------------------------------------------------------------------------------
# Function
#------------------------------------------------------------------------------
sub writeCompVersions {

# Determine the diffState  
  foreach $itemComp (keys %comp) {
    if ($comp{$itemComp}{version1} eq $comp{$itemComp}{version2}) {
      $comp{$itemComp}{diffState} = "SAME";
    }
    elsif ($comp{$itemComp}{version1} eq "") {
      $comp{$itemComp}{version1}  = $STR_EMPTY;
      $comp{$itemComp}{diffState} = "UNIQUE";
    }
    elsif ($comp{$itemComp}{version2} eq "") {
      $comp{$itemComp}{version2}  = $STR_EMPTY;
      $comp{$itemComp}{diffState} = "UNIQUE";
    }
    elsif ($comp{$itemComp}{version1} ne $comp{$itemComp}{version2}) {
      $comp{$itemComp}{diffState} = "DIFFERENT";
    }
  }


# Print result in particular order (by category, then alphabetical 
# within category).
  foreach $itemCompRef (sort { 
                         $a->[0] <=> $b->[0]   # note reverse sort!
                                 ||
                         $a->[1] cmp $b->[1]
                         }
                    map  { [
                             $DS{$comp{$_}{diffState}}{order}, 
                             $_,
                         ] }
                    keys %comp) {

    $itemComp = $itemCompRef->[1];
    printf ("%-12s  %-25s  %-12s  %-12s\n"
           , $DS{$comp{$itemComp}{diffState}}{str}
           , $itemComp 
           , $comp{$itemComp}{version1}
           , $comp{$itemComp}{version2}
           );   # closing semi-colon
  }

# print "exiting $FUNCNAME $FUNCVERSION\n\n";
}

__END__


#last line
