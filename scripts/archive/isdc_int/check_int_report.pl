#!/usr/bin/perl
#
#  My little tool to double-check my integration reports.  Assumes:
#   -  reports in ~/reports/*<version>.txt
#   -  ISDC_ENV set correctly
#
#  It will take everything in the reports and try to verify the version 
#   number given.  Firstly, it'll just compile lists of versions and
#   components in integration reports and in VERSION files.  Then it
#   compares the two lists component by component.  If there is any
#   discrepancy, the command `component --v` is tried to resolve it.
#   Obviously, this won't work for libraries, so you'll have to check
#   yourself that those extras were really installed and tested.  
#

use File::Basename;

my $int_vers = "";
my $system;
my @int_files;
my %integration;
my %compare;
my $component;
my $check;
my $warnings = 0;
my $errors = 0;
my $debug = 0;
my $debugfile;
my $diff;
my $diffcount;
my @prev_files;
my @version_files;
my $search;
my $print;
my $latest;
#############
#  Get arguments
#############

foreach (@ARGV) {
  if (/--h/) {
  print "USAGE:  check_int_report.pl [--current_version=] [--prefix=] [--diff_version=] [--print]\n\twhere\n\t--current_version is the version of the integration, e.g. \'6.3\'\n\t--prefix is an optional subset of those, e.g. \'NRT\'.\n\t--diff_version gives version to compare to (otherwise to current build VERSION file.)\n\t--print then prints all components without comments\n\n\tExamples:   \'check_int_report.pl --prefix=NRTREV --print\' to generate dependencies list for nrtrev component.\n\tGiving --diff_version tells it also to print the components updated in format for icms_release_update command line\n";
  exit;
}
  elsif (/--current_version=(.*)$/) {
    $int_vers = $1;
  }
  elsif (/--prefix=(.*)$/) {
    $system = $1;
  }
  elsif (/--debug/) {
    $debug++;
  }
  elsif (/--diff_version=(.*)$/) {
    $diff = $1;
  }
  elsif (/--print/) {
    $print++;
  }

  else {
    die ">>>>>>>     ERROR:  don't recognize parameter $_\n";
  }
} 

print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
print ">>>>>>>     Comparing ";
print "$system " if ($system);
print "Integration version $int_vers with $ENV{ISDC_ENV} build\n" unless ($diff);
print "Integration version $int_vers with $diff\n" if ($diff);
print ">>>>>>>     Running in DEBUG mode;  creating ~/tmp_check_int/* files\n" if ($debug);

print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";

#############
#  First, get the integration files
#############
if ($int_version) {
  $search = "/home/isdc_guest/isdc_int/reports/old/*integration${int_vers}.txt" unless ($system);
  $search = "/home/isdc_guest/isdc_int/reports/old/${system}*integration${int_vers}.txt" if ($system);
}
else {
  $search = "/home/isdc_guest/isdc_int/reports/*integration.txt" unless ($system);
  $search = "/home/isdc_guest/isdc_int/reports/${system}*integration.txt" if ($system);
}

@int_files = `ls $search 2> /dev/null`;

die ">>>>>>>     ERROR:  Ooops, can't find $system Int reports at $search .\n" unless (@int_files);


if ($diff) {
  @prev_files = `ls /home/isdc_guest/isdc_int/reports/old/${system}*integration-${diff}.txt`;
  die ">>>>>>>     ERROR:  Ooops, can't find old Int reports at /home/isdc_guest/isdc_int/reports/old/${system}*integration-${diff}.txt.\n" unless (@prev_files);
}



#############
#  Then, go get the VERSION files (unless you're diffing versions of reports)
#############

if (!($diff)) {
  @version_files = `ls $ENV{ISDC_ENV}/VERSION 2> /dev/null`;
  # (Since sometimes I use subdirs for SCW, REV, etc.
  #push @version_files, sort(glob("$ENV{ISDC_ENV}/*/VERSION"));
  die ">>>>>>>     ERROR:  Ooops, can't find $ENV{ISDC_ENV}/VERSION\n" unless (@version_files);
}

#############
#  Use handy function to parse these files and fill hashes of 
#   form component=>version:
#############

print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
print ">>>>>>>     Examining Integration Reports $int_vers...\n";
FillHash(\%integration,\$errors,\$warnings,@int_files);
if (defined($integration{"support-sw"})) {
  #  Function to replace support-sw entry with each individual component,
  #   since they're listed individually in VERSION file.
  FillHashSupport(\%integration);
}

if ($diff) {
  print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
  print ">>>>>>>     Examining Integration Reports $diff ...\n";
  FillHash(\%compare,\$errors,\$warnings,@prev_files);
  if (defined($compare{"support-sw"})) {
    #  Function to replace support-sw entry with each individual component,
    #   since they're listed individually in VERSION file.
    FillHashSupport(\%compare);
  }
}
else {
  print ">>>>>>>\n";
  print ">>>>>>>     Examining VERSION file(s)...\n";
  FillHash(\%compare,\$errors,\$warnings,@version_files);
  print ">>>>>>>\n";
}

#############
#  Create DEBUG stuff
#############

if ($debug) {
  mkdir "$ENV{HOME}/tmp_check_int",0755 unless (-d "$ENV{HOME}/tmp_check_int");
  
  #  Print the total integration which resulted
  $debugfile = "$ENV{HOME}/tmp_check_int/Integration";
  open DEBUG,">$debugfile" or die ">>>>>>>     ERROR:  cannot open $debugfile to write\n";
  foreach (sort(keys(%integration))) { 
    print DEBUG "$_ $integration{$_}\n";
  }
  close DEBUG if ($debug);
  
  #  Print the total build which resulted
  $debugfile = "$ENV{HOME}/tmp_check_int/Compare";
  open DEBUG,">$debugfile" or die ">>>>>>>     ERROR:  cannot open $debugfile to write\n";
  foreach (sort(keys(%compare))) { 
    print DEBUG "$_ $compare{$_}\n";
  }
  close DEBUG if ($debug);
   
}

#############
#  Now compare the hashes:
#############

#  Go through all Integration Reports components first:
print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
print ">>>>>>>     Now comparing:\n";
print ">>>>>>>    parameters to icms_release_update then include:\n" if ($diff);
print ">>>>>>>\n";
foreach $component (keys(%integration)) {

  #  Check if it's in compare
  if (defined($compare{$component})) {
    if ($integration{$component} ne $compare{$component}) {
      if ($diff) {
#	print ">>>>>>>     DIFF:  component $component is version $integration{$component} in current $int_vers and $compare{$component} in ${diff} files.\n";
	print "${component}-$integration{$component} " unless ($component =~ /ic\stree/i);
	$diffcount++;
      }
      else {
	print ">>>>>>>     ERROR:  component $component is version $integration{$component} in Int. Repts and $compare{$component} in VERSION files.\n" unless ($diff);
	$errors++;
      } # if not diff
    } # if files don't match
  }  # if defined in both

  elsif ($component =~ /preproc|pipeline_lib|adp|input|nrtscw|consscw|rev|qla|conssa/i) {
    if ($diff) {
      print ">>>>>>>     DIFF:  component $component not listed in $diff files\n";
#      print "${component}-$integration{$component} ";
      $diffcount++;
    }
    else {
      print ">>>>>>>     WARNING:  component $component not listed in VERSION files\n";
      $warnings++;
    } # if not diff
  } # if preproc, pipeline_lib, etc.

  elsif ($component =~ /ic\s+tree|opus|opusmgrs|support-sw/i) {
    #  These aren't going to bein the VERSION file, but will be in a diff
    print ">>>>>>>     DIFF:  component $component not defined in $diff\n" if ($diff);
    $diffcount++;
  }

  else {
    if ($diff) {
#      print ">>>>>>>     DIFF:  component $component not listed in $diff\n";
      print "${component}-$integration{$component} ";
      $diffcount++;
    }
    else {
      print ">>>>>>>     ERROR: component $component not listed in VERSION files\n";
      $errors++;
    }

  } # if not defined in compare



  #############
  #  Check the component itself as built (unless doing diff)
  #############
  if (!($diff)) {
    #  Skip next check for dependencies:
    next if ($component =~ /preproc|IC\stree|opus|opusmgrs|isdcroot/i);
    #  Now, regardless, check whether `component --v` matches:
    $check = `which $component 2> /dev/null`;
    #  Which for some reason returns to STDOUT "no $component in /...."
    #  or sometimes:
    #
    #   Warning: ridiculously long PATH truncated
    #   no $component in /....

    #  So, if you didn't get an error:
    if ($check !~ /no\s$component/) {
      $check = `$component --v 2> /dev/null`;
      chomp $check;
      $check =~ s/^.*$component\s*(\S+)\s*$/$1/;
      if ( ($check) && ($check ne $integration{$component}))  {
	print ">>>>>>>     ERROR:  component $component is version $integration{$component} in Int. Repts. but says it's version $check\n";
	$errors++;
      }
    }

  } # if not diff
  
}  # for each integration component

print "\n";

#  Now the reverse: go through compared entries and compare to Int Reports,
#   though in this case, we're only interested in finding things not defined
#   in the Int Reports:

if (!($print)) {
  print "\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
  print ">>>>>>>     Checking for things missing from Int Reports:\n";
  print ">>>>>>>\n";
  foreach $component (keys(%compare)) {
    
    if (!defined($integration{$component})) {
      if ($diff) {
	print ">>>>>>>     DIFF:  component $component not listed in Int Reports.\n";  
	$diffcount++;
      }
      else {
	print ">>>>>>>     WARNING:  component $component not listed in Int Reports.\n";
	$warnings++;
      }
    } # if not defined
  }  # for each compare component, check in in report

  if (!($diff)) {
    print "\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
    print ">>>>>>>     Checking VERSION file for more recent deliveries:\n";
    print ">>>>>>>\n";
    foreach $component (keys(%compare)) {
      
      $latest = `/home/isdc/isdc_cms/icms/scripts/icms_comp_print_versions.sh --latest $component`;
      die ">>>>>>>     ERROR:  cannot check for latest:  $latest\n" if ($?);
      chomp $latest;
      $latest =~ s/$component\s+(\d.*)$/$1/;
      if ($compare{$component} ne $latest) {
	print ">>>>>>>     NOTE:  component $component has later version $latest\n";
      }
      
    } # end foreach component again, if newer version

  } # end if not diff

} # if not print


elsif ( ($print) && !($errors)) {
  #  Now just print all components in a format friendly to a delivery note:

  print ">>>>>>>     The following then make the dependencies list:\n";
  foreach (sort keys %integration) {
    #  Don't print components like Preproc, OpusMgrs, or the current delivery
    #   which is the same in lower case as the prefix
    print "$_ $integration{$_} " unless ( (/preproc|opus|ic\stree/i) || (/$system/i) );
  }
  print "\n";
#  print ">>>>>>>     (Don't forget to add the Perl components, not listed there.\n";

}

print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
print ">>>>>>>\n";
print ">>>>>>>     DONE.  There were $warnings warnings and $errors errors.\n" unless ($diff);
print ">>>>>>>     DONE.  There were $diffcount differences.\n" if ($diff);

exit;


#############
#  Little subroutine to parse Integration Reports and VERSION files
#############
sub FillHash {
  #  Give it reference to a hash to fill and an array of files to parse:
  #    FillHash( \%hash_to_fill, @files_to_parse)
  #
  #  For each key, if it's already defined, a warning is printed listing
  #   the current and stored values:  i.e. do you have different versions
  #   of something?  
  #  
  #
  #  Note that for some reason, the order matters here:  if you try to
  #   pass the references after the array, they don't work.  
  my ($hashref,$errorsref,$warningsref,@files) = @_;
  my $component;
  my $vers;
  my $file;
  my %tmphash;


  foreach $file ( @files ) {
    chomp $file;
    #  TO BE FIXED:  for now, NRTQLA and CONSSA aren't in sync.  So if you
    #    say --prefix=NRT, we ignore QLA.  To check QLA, say --prefix=NRTQLA
    #    and check it by itself.  
    next if ( ($file =~ /(qla|conssa)/i) && ($system !~ /$1/i));
    open INT, "$file" or die ">>>>>>>     ERROR:  cannot open $file to read\n";

    if ($debug) {
      mkdir "$ENV{HOME}/tmp_check_int",0755 unless (-d "$ENV{HOME}/tmp_check_int");  $debugfile = "$ENV{HOME}/tmp_check_int/".File::Basename::fileparse($file,'\..*').".debug";
      open DEBUG,">$debugfile" or die ">>>>>>>     ERROR:  cannot open $debugfile to write\n";
    } 

    while (<INT>) {
      next unless (/\w/);# blank lines
      #  Ignore comments, except those for dependencies:  "preproc",
      #   "IC tree", "OPUS", or "OpusMgrs".
      next if ( (/^\s*\#/) && !(/^\s*\#\s*(preproc|IC\stree|opus|opusmgrs)\s+/i) );# comments
      
      # <space><component><space><version><space,return,or comment>
      (/^\s*#\s*(preproc|IC\stree|opus|opusmgrs)\s+(\S+)\s*.*$/i) or (/^\s*(\S+)\s+(\S+)\s*.*$/);
      $component = $1;
      $vers = $2;

#  If this component is already in the final hash table, then it must have
#   been in a different file (e.g. multiple NRT files);  always want to 
#   print this warning if the versions aren't the same      
      if (defined($$hashref{$component})) {
	print ">>>>>>>     ERROR:  component $component has different versions:  $$hashref{$component} (previous) and $vers (in $file)!!  Replacing with latter...\n" if ($$hashref{$component} ne $vers);
	$$errorsref++ if ($$hashref{$component} ne $vers);
      }
#  But if this component is already in the tmphash, that only means it's 
#   defined twice in the same file, e.g. VERSION file which had support-sw
#   specified and then a component of that updated.  Don't want to
#   print this warning unless debug mode on:
      if (defined($tmphash{$component})) {
	print ">>>>>>>     WARNING:  component $component has different versions:  $tmphash{$component} (previous) and $vers (in $file)!!  Replacing with latter...\n" if ( ($tmphash{$component} ne $vers) && ($debug) ) ;
	$$warningsref++ if ( ($tmphash{$component} ne $vers) && ($debug) );
      }
#  So don't put entry in final has table yet;  wait for all file to
#   be done, i.e. out of while loop, so the above logging will work right.
#      $$hashref{$component} = $vers;
      $tmphash{$component} = $vers;
       print DEBUG "$component $vers\n" if ($debug);
#      print ">>>>>>>     ${file}:  component $component version $vers\n";

    } # while

    #  Now, have filled tmphash, but not $$hashref.  Do it here:
    foreach (keys(%tmphash)) { 
      $$hashref{$_} = $tmphash{$_};
    }

    close DEBUG if ($debug);
    close INT;
  }  # end of foreach integration file
} # end FillHash

sub FillHashSupport {
  #  Give it reference to a hash with support-sw component, replace that
  #    key with hash of the individual components
  print ">>>>>>>     (Found support-sw listed in Int report;  expanding...)\n";
  my ($hashref) = @_;
  my $component;
  my $vers;
  my $use = 1;
  if ($debug) {
    open (DEBUG, ">$ENV{HOME}/tmp_check_int/Support")  or die ">>>>>>>     ERROR:  cannot open$ENV{HOME}/tmp_check_int/Support  to write\n";
  }

  my $support_version = $$hashref{"support-sw"};
  delete $$hashref{"support-sw"};
  die ">>>>>>>     ERROR:  support-sw version not defined!\n" unless ($support_version);
  my $support_file = "/home/isdc/isdc_cms/icms/lists/released/support-sw-${support_version}";
  die ">>>>>>>     ERROR:  cannot find support-sw file $support_file\n" unless (-e "$support_file");

  open VERS, "$support_file" or die ">>>>>>>     ERROR:  cannot open support-sw file $support_file\n";
  while (<VERS>) {
    $use = 1;
    next unless (/\w/);# blank lines
    #  Ignore comments, except those for dependencies:  "preproc",
    #   "IC tree", "OPUS", or "OpusMgrs".
    next if ( (/^\s*\#/) && !(/^\s*\#\s*(preproc|IC\stree|opus|opusmgrs)\s+/i) );# comments
    
    # <space><component><space><version><space,return,or comment>
    (/^\s*#\s*(preproc|IC\stree|opus|opusmgrs)\s+(\S+)\s*.*$/i) or (/^\s*(\S+)\s+(\S+)\s*.*$/);
    $component = $1;
    $vers = $2;
     
    if (defined($$hashref{$component})) {
      print ">>>>>>>     WARNING:  component $component has different versions:  $$hashref{$component} (previous) and $vers (support-sw)!!  Not using support-sw version but former.\n" if ( ($$hashref{$component} ne $vers) && ($debug));
      $use = 0;
    }
    $$hashref{$component} = $vers if ($use);
     print DEBUG "$component $vers\n" if ($debug);
    #print ">>>>>>>     ${file}:  component $component version $vers\n";
     
  } # end while VERS
  close INT;
    close DEBUG if ($debug);
    
} # end FillHashSupport
		    
