#!/isdc/sw/perl/5.6.0/WS/prod/bin/perl
#
#
#
#  Tool to diff two VERSION-type files, with the point of updating the first
#   with the versions in the second:



#############
#  Get arguments
#############

if ($ARGV[0] =~ /--h/) {
  print "\n\tUSAGE:  diff_versions.pl <file to update> [<file to compare against>]\n";
  exit;
}
my $current = $ARGV[0];
my $compare = $ARGV[1];

die ">>>>>>>     ERROR:  please give correct current files.\n" unless (-e "$current");

my %current;
my %compare;
my $thiscomp;
my $thisvers;
my $thisline;
my $thiscomment;
my $badvers;



print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
print ">>>>>>>     Examining Current file $current...\n";
FillHash(\%current,$current);

if (-e "$compare") {
  print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
  print ">>>>>>>     Examining Compare file $compare...\n";
  FillHash(\%compare,$compare);
}

print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
print ">>>>>>>     Creating new file based on differences...\n" if (-e "$compare");
print ">>>>>>>     Creating new file based on latest deliveries...\n" unless (-e "$compare");

open(NEW,">${current}.new") or die ">>>>>>>     ERROR:  cannot open ${current}.new to write\n";

open(OLD,"$current") or die ">>>>>>>     ERROR:  cannot open $current to read!\n";

while (<OLD>) {
  chomp;
  $thisline = $_;
  
  if ( !($thisline =~ /^\s*\#/) && ($thisline =~ /^\s*(\S+)\s+(\S+)/) ) {
    $thiscomp = $1;
    $thisvers = $2;
    $thiscomment = "";
    $badvers = "";
    #  Couldn't figure out how to get this in the above, which may or may
    #   not be there, without failing to match;  so do it dumb way:
    if ($thisline =~ /^\s*\S+\s+\S+\s+(.*)$/) { $thiscomment = $1; }

    if ($thiscomment =~ /do_not_change_to_(\S+)/) {
      #  This is a way to specifically skip a version, even though it might
      #   be later.
      $badvers = $1;
    }

    #  Case 1:  comparison list exists, component is listed in it, and
    #   versions are different;  use comparison version:
    if ( (defined $compare{$thiscomp}) && ($compare{$thiscomp} ne $thisvers) && ($compare{$thiscomp} ne $badvers) ) {
      #      print NEW "$thiscomp\t\t$compare{$thiscomp} (changed from $thisvers) \n";
      printf NEW "%-30s%-10s  (changed from $thisvers) $thiscomment\n",$thiscomp,$compare{$thiscomp};
    }  # end case 1

    #  Case 2:  comparison list exists, component is listed in it, and
    #   versions are the same;  no change:
    elsif ( (defined $compare{$thiscomp}) && ($compare{$thiscomp} eq $thisvers) ) {
      printf NEW "%-30s%-10s\n",$thiscomp,$compare{$thiscomp};
    }  # end case 2


    #  Case 3:  comparison list exists, component not included;  no change:
    elsif ( (-e "$compare") && !(defined $compare{thiscomp}) ) {
      printf NEW "%-30s%-10s\n",$thiscomp,$thisvers;  
    } # end case 3


    #  Case 4: no comparison list exists, check for latest:
    elsif (!-e "$compare") {

      $compare{$thiscomp} = `/home/isdc/isdc_cms/icms/scripts/icms_comp_print_versions.sh --latest $thiscomp`;
      chomp $compare{$thiscomp};
      $compare{$thiscomp} =~ s/$thiscomp\s+(\d.*)$/$1/;

      printf NEW "%-30s%-10s$thiscomment\n",$thiscomp,$thisvers if  ( ($thisvers eq $compare{$thiscomp})  || ($compare{$thiscomp} eq $badvers) );
      printf NEW "%-30s%-10s  (changed from $thisvers) $thiscomment\n",$thiscomp,$compare{$thiscomp} if ( ($thisvers ne $compare{$thiscomp}) && ($compare{$thiscomp} ne $badvers) );
    } # end case 4

    else {
      die "*******     ERROR:  I'm confused.  How did I get here?\n";
    }


    
  } # end if got component version line
  else {
    print NEW $thisline."\n";
    next;
  } # if comment or something
  
} # end while OLD
  
  
#  Find anything in compare file not in current:
if (-e "$compare") {
  print NEW "#\n#\n#    Things in $compare but missing from last version:\n#\n";
  foreach (keys %compare) {
    if (!defined($current{$_})) {
      printf NEW "#%-30s%-10s\n",$_, $compare{$_};
    }
  } # foreach in compare
}
close OLD;
close NEW;

rename "$current", "${current}.old";
rename "${current}.new", "$current";

print ">>>>>>>>     DONE.\n";


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
  my ($hashref,@files) = @_;
  my $component;
  my $vers;
  my $file;
  my %tmphash;


  foreach $file ( @files ) {
    chomp $file;
    #  TO BE FIXED:  for now, NRTQLA and CONSSA aren't in sync.  So if you
    #    say --prefix=NRT, we ignore QLA.  To check QLA, say --prefix=NRTQLA
    #    and check it by itself.  
#    next if ( ($file =~ /(qla|conssa)/i) && ($system !~ /$1/i));
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
		    
