#!/isdc/sw/perl/5.6.0/WS/prod/bin/perl -w
#
#  Little script to create new version entry in regression directories.

use File::Basename;

#  Default input and output locations:
my $topdir =  "/home/isdc_guest/isdc_int/regression/";

#  Default contents of each version subdir:
my $version_file_name     = "VERSION";
my $analysis_file_name    = "dircmp.analysis";
my $env_file_name         = "env_dump.txt";
my $integration_file_name = "integration.txt";
my $diffFileAll_name      = "tmp_isdc_dircmp/diffFileAll.log";
my $dircmp_out_name       = "tmp_isdc_dircmp/isdc_dircmp.out";
my $debug_info_name       = "debug.html";
my $flag_file_name        = "flag.html";

my ($this_tar_version,@files,$last_tarfile,$new_tarfile,$last_delivered);
my ($previous,$root,$integration,$retval,$rename);

my $pipeline;
my @versions;
my @integrations;
my $version;
my $date;
my @commands;
my $command;
my @result;
my $debug = 1;
my $flag = ""; # add the = "" 040101 bc was giving "Using uninitialize variable warning"
my $diff;
my $prefix = ">>>  ";

########
#  Read in command line args, if any:  
########
foreach (@ARGV) {
	if (/--h/) {
		print "\nUSAGE:  gen_diff_entry.pl [--h] --version= --pipeline= [--quiet] [--flag=]\n\n"
			."where version is the new version entry you want to create for pipeline.\n\n";
		print "This is to be run after updating software and re-running the unit test.  "
			."Update the integration report and $version_file_name file manually before running this, and set up FTOOLS.  "
			."It will automatically create the necessary files in ~/regression/<pipeline>/<version>.\n\n";
		print "If --flag=question, a question mark flag is used;  if --flag=check, a check is used;  "
			."if no flag is specified, the script will check the size of the diffFileAll.  "
			."If that file is empty, zero differences are assumed and no flag set;  "
			."if that file is not empty, the question flag is used.\n\n";
		print "Afterwards, the $analysis_file_name should be created manually.\n\n";
		exit;
	}
	elsif (/--quiet/) {
		$debug--;
	}
	elsif (/--(path|pipeline)=(.*)$/) {
		$pipeline = $2;
		print "$prefix Working with pipeline $pipeline\n" if ($debug);
	}
	elsif (/--version=(.*)$/) {
		$version = $1;
		print "$prefix Creating entry for version $version\n" if ($debug);
	}
	elsif (/--flag=(.*$)/) {
		$flag = $1;
	}
} 

die "$prefix ERROR:  please specify both version and pipeline\n" unless ( ($version) && ($pipeline));

#	040604 - Jake - added because if this exists and there are diffs, it crashes near the end
die "$prefix ERROR:  outref.old directory exist from previous gen_diff_page.pl run.\n" if ( -d "$ENV{ISDC_OPUS}/$pipeline/unit_test/outref.old" );

########
#  Check version given:
########

#	0405?? - Jake - commented out because don't know why its here in the first place
#	die "$prefix ERROR:  don't give X.0 but just X.\n" if ($version =~ /\.0$/);	#	Why not?

@versions = glob("$topdir/$pipeline/*") ;
foreach (@versions) { $_ = basename $_;}

#  Funny sorting so 11.9.2 comes before 11.10:
@versions = sort byversion @versions;

$previous = $versions[$#versions];
print "$prefix Previous version is $previous\n" if ($debug);

#  Warning;  grep with version=12.9.2 uses the . as a placeholder, not as
#   a dot, so careful if there's anything like "12x9y2", not that I can see
#   how that would happen until we get to *really* big versions!
die "$prefix ERROR:  version $version not greater than previous $previous.\n" 
	if (grep /${version}$/, @versions);  

########
# find the last integration report
########
$root = $pipeline;
$root =~ tr/a-z/A-Z/;
$integration = "/home/isdc_guest/isdc_int/reports/${root}${integration_file_name}";


########
#  Easy initial steps:
########

#	add these 2 variables to simplify the code's appearance
my $root_dir = "$topdir/$pipeline/$version";
my $prev_dir = "$topdir/$pipeline/$previous";


# make directory
push @commands, "mkdir -p $root_dir";
# copy VERSION file
push @commands, "cp $ENV{ISDC_ENV}/$version_file_name $root_dir";
# copy env_debug
push @commands, "cp $ENV{ISDC_OPUS}/$pipeline/unit_test/$env_file_name $root_dir";
# copy integration report
push @commands, "cp $integration $root_dir/$integration_file_name";
# sdiff VERSION and previous
#push @commands, "sdiff -s $prev_dir/$version_file_name $root_dir/$version_file_name > $root_dir/change";
# create date file
push @commands, "date > $root_dir/date";
push @commands, "echo $ENV{ISDC_IC_TREE} >  $root_dir/ic_tree" if ( $ENV{ISDC_IC_TREE} );
push @commands, "echo $ENV{ISDC_REF_CAT} >  $root_dir/ref_cat";

foreach $command (@commands) {
	print "$prefix Running:  $command\n" if ($debug);
	@result = `$command`;
	if (($?) && ($command !~ /diff/)) {
		die "$prefix ERROR:  cannot run command \'$command\'\n";
	}
} #end foreach command

########
#  Generate change file
########
@commands = ();

push @commands, 
	"awk '\$0 !~ /^#/{print \$1,\$2}' $prev_dir/$version_file_name | sort "
		."> $root_dir/$version_file_name.previous.sorted";

push @commands, "echo ISDC_IC_TREE $ENV{ISDC_IC_TREE} >> $root_dir/$version_file_name" if ( $ENV{ISDC_IC_TREE} );
push @commands, "echo ISDC_REF_CAT $ENV{ISDC_REF_CAT} >> $root_dir/$version_file_name";

push @commands, "awk '\$0 !~ /^#/{print \$1,\$2}' $root_dir/$version_file_name | sort "
		."> $root_dir/$version_file_name.sorted";

push @commands, 
	"sdiff -s $root_dir/$version_file_name.previous.sorted $root_dir/$version_file_name.sorted "
		."> $root_dir/change"; 

foreach $command (@commands) {
	print "$prefix Running:  $command\n" if ($debug);
	@result = `$command`;
	if (($?) && ($command !~ /diff/)) {
		die "$prefix ERROR:  cannot run command \'$command\'\n";
	}
} #end foreach command



########
#  Now run isdc_dircmp
########

chdir "$root_dir" or die "$prefix ERROR:  cannot chdir to $root_dir\n";
$command = "isdc_dircmp --cwdtmp $ENV{ISDC_OPUS}/$pipeline/unit_test/outref $ENV{ISDC_OPUS}/$pipeline/unit_test/out";
print "$prefix Running:  $command\n" if ($debug);
`$command`;
$retval = $? / 256;
$diff = $retval;
die "$prefix ERROR:  status $retval from command \'$command\'\n" if ( ($retval != 0) && ($retval != 1));


#######
#  move data
#######
@commands = ();

if (-d "$prev_dir/out") {
	push @commands, "chmod -R +w $prev_dir/out";
	push @commands, "chmod +w $prev_dir";
	push @commands, "rm -r $prev_dir/out/scw"        if (-d "$prev_dir/out/scw");
	push @commands, "rm -r $prev_dir/out/aux"        if (-d "$prev_dir/out/aux");
	push @commands, "rm -r $prev_dir/out/idx"        if (-d "$prev_dir/out/idx");
	push @commands, "rm -r $prev_dir/out/obs"        if (-d "$prev_dir/out/obs");
	push @commands, "rm -r $prev_dir/out/obs_isgri"  if (-d "$prev_dir/out/obs_isgri");
	push @commands, "rm -r $prev_dir/out/obs_jmx"    if (-d "$prev_dir/out/obs_jmx");
	push @commands, "rm -r $prev_dir/out/obs_picsit" if (-d "$prev_dir/out/obs_picsit");
	push @commands, "rm -r $prev_dir/out/obs_spi"    if (-d "$prev_dir/out/obs_spi");
	push @commands, "rm -r $prev_dir/out/obs_omc"    if (-d "$prev_dir/out/obs_omc");
	push @commands, "chmod -R -w $prev_dir";
}



#	051021 - Jake - added the -L (to actually copy the data) and change -r to -R
#		this caused an intersting problem, as the link was copied.  Then the next time
#		I ran this, the rm removed the new out data because it followed the link.
#		Had me runnin' 'round in circles for a while.
push @commands, "cp -RL $ENV{ISDC_OPUS}/$pipeline/unit_test/out $root_dir/";
#push @commands, "cp -r $ENV{ISDC_OPUS}/$pipeline/unit_test/out $root_dir/";




push @commands, "cp $ENV{ISDC_OPUS}/$pipeline/unit_test/test_data/*txt $root_dir/out" 
	if (glob("$ENV{ISDC_OPUS}/$pipeline/unit_test/test_data/*txt"));
push @commands, "cp -r $ENV{ISDC_OPUS}/$pipeline/unit_test/test_data/logs $root_dir/out" 
	if (glob("$ENV{ISDC_OPUS}/$pipeline/unit_test/test_data/logs/*"));
push @commands, "chmod +w $root_dir/out";
push @commands, "cp -r $ENV{ISDC_OPUS}/$pipeline/unit_test/test_data/scw/*/logs $root_dir/out" 
	if (glob("$ENV{ISDC_OPUS}/$pipeline/unit_test/test_data/scw/*/logs"));
push @commands, "chmod -R -w $root_dir/out";

foreach $command (@commands) {
	print "$prefix Running:  $command\n" if ($debug);
	@result = `$command`;
	exit $? if ($?);
} #end foreach command


########
#  Generate small page of debug links
########

open(DEBUG,">$root_dir/$debug_info_name") 
	or die "ERROR:  cannot open $root_dir/$debug_info_name to write.\n";

#  dircmp output
print DEBUG "<a href=$dircmp_out_name>$dircmp_out_name</a>\n<p>\n";

#  dircmp diffFileAll
print DEBUG "<a href=$diffFileAll_name>$diffFileAll_name</a>\n<p>\n";

#  Env debug log
print DEBUG "<a href=$env_file_name>$env_file_name</a>\n<p>\n";

close DEBUG;

#  Check for a flag:
if ($flag =~ /question/) {
	`cp $ENV{HOME}/WWW/question_$flag_file_name $root_dir/$flag_file_name`;
} elsif ($flag =~ /check/) {
	`cp $ENV{HOME}/WWW/check_$flag_file_name $root_dir/$flag_file_name`;
} elsif (-z "$root_dir/$diffFileAll_name") {
	#	apparently do nothing special
} else {
	print "WARNING:  no flag specified but differences exist, setting question flag.\n";
	`cp $ENV{HOME}/WWW/question_$flag_file_name $root_dir/$flag_file_name`;
}

chdir "$ENV{ISDC_OPUS}/$pipeline/unit_test/" 
	or die "*******     Cannot chdir to $ENV{ISDC_OPUS}/$pipeline/unit_test/";


#######
#  If differences found, tar file to be updated:
#######

if ($diff > 0) {
	print "$prefix Found differences;   updating tar file.\n";
	$rename = 1;

	#	this next command also removes all previous items in @commands!
	@commands = ( "mv outref outref.old" );		#	040210 - Jake - save outref (just in case I screw up)
	
	if ( $pipeline eq "conssa"  || 		#	original
		$pipeline eq "nrtinput"  ||		#	040301 - Jake
		$pipeline eq "nrtscw"    ||		#	040301 - Jake
		$pipeline eq "nrtrev"    ||		#	040301 - Jake
		$pipeline eq "consinput" ||		#	040301 - Jake
		$pipeline eq "consscw"   ||		#	040301 - Jake
		$pipeline eq "consrev"   ||		#	040301 - Jake
		$pipeline eq "adp"       ||		#	040310 - Jake
		$pipeline eq "consssa"   ||		#	040927 - Jake
		$pipeline eq "nrtqla" ) {			#	original
		@files = `ls -1 $ENV{ISDC_TEST_DATA_DIR}/$pipeline-*_outref.tar.gz`
	} else {
		#	You shouldn't get here
		print "\n\n\n\nSomething wrong! Shouldn't be here!\n"
			."Unrecognized pipeline name : $pipeline \n\n\n\n";
		exit;
	}

	print "$prefix Found old tar files:  \n@files\n";
	chomp $files[$#files] if (@files);

	#	050916 - Jake
	#	could very possibly be no outref.tar.gz if they have not changed since last delivery
	#	this will ensure that all the variables used are defined.
	if (@files) {
		$new_tarfile = $files[$#files];
	} else {
		$new_tarfile = "$ENV{ISDC_TEST_DATA_DIR}/$pipeline-0.0_outref.tar.gz";
	}
	$last_tarfile = $new_tarfile;
	
#	$new_tarfile = $files[$#files] if (@files);					#	040802 - Jake - added the if
#	#  may rename new below if version needs to be updated
#	$last_tarfile = $new_tarfile if (@files);						#	040802 - Jake - added the if
#	$last_tarfile = "$ENV{ISDC_TEST_DATA_DIR}/$pipeline-0.0_outref.tar.gz" unless (@files);	#	040802 - Jake - new line in case there isn't an outref file

	
	######
	#  Find last delivery and check that the new test data targz isn't
	#   named with the same version;  if so, increment by 0.1 for next.
	#   (Note:  this version is the component version, not the regression
	#   version.)
	######
	
	@files = `ls -1 $ENV{HOME}/deliveries/$pipeline/$pipeline-*.tar.gz`;
	$files[0] = "$ENV{HOME}/deliveries/$pipeline/$pipeline-0.0.tar.gz" unless ( @files );
	
	print "$prefix Found deliveries:  \n@files\n";
	chomp $files[$#files];
	
	$last_delivered = $files[$#files];
	$last_delivered =~ s/^(.*)-(\S+)\.tar\.gz$/$2/;
	print "$prefix Last delivered version is $last_delivered\n";
	
	$this_tar_version = $new_tarfile;
	
	$this_tar_version =~ s/^.*${pipeline}-(\S+)_outref\.tar\.gz$/$1/;				#	040130 - Jake added this
	
	print "$prefix Last outref tar file version is $this_tar_version\n";
	
	#  Since I often forget to rename the test data targz after delivering,
	#   check here
	
	#	040628 - Jake - trying <= instead of == because can happen
	#		on the off chance that a delivery had no diffs
	if ($this_tar_version <= $last_delivered) {		
		#  %.1f forces e.g. 6 to be printed 6.0
		$this_tar_version = sprintf("%.1f", ($last_delivered + 0.1) );		#	040628 - Jake - last and not this
		print "$prefix WARNING:  updating outref file corresponding to last delivery!  Will name with a new version number $this_tar_version.\n";
		$rename--;
		$new_tarfile = "$ENV{ISDC_TEST_DATA_DIR}/$pipeline-${this_tar_version}_outref.tar.gz";		#	outref now, not test_data
	}
	else {
		print "$prefix Updating outref tar file without changing version number.\n";
	}
	
	push @commands, "mv $last_tarfile $last_tarfile.$previous" if ($rename);
	
	#  replace with new
	push @commands, "mv out outref; ";

	#	Jake 040213 (need the \\; to get \;) # fixed 040217
	#	050926 - Jake - Added the -follow because now outref may be a link
	push @commands, "find outref -type d -follow -exec chmod u+wx {} \\;";
	
	# 040119 - Jake changed to if statement instead of an unless and and if
	#  Create new tar file. 
	if ( $pipeline eq "conssa" ||		#	original
		$pipeline eq "nrtqla"   ||		#	0401?? - Jake
		$pipeline eq "nrtscw"   ||		#	040202 - Jake
		$pipeline eq "consscw"  ||		#	040202 - Jake
		$pipeline eq "consinput"||		#	040301 - Jake
		$pipeline eq "adp"      ||		#	040310 - Jake
		$pipeline eq "nrtrev"   ||		#	040406 - Jake
		$pipeline eq "consrev"  ||		#	040406 - Jake
		$pipeline eq "consssa"  ||		#	040927 - Jake
		$pipeline eq "nrtinput" ) {	#	040301 - Jake

		#	050926 - Jake - Added the 'h' because now outref may be a link
		push @commands, "/bin/tar cfh - outref | /bin/gzip > $new_tarfile";
		#push @commands, "/bin/tar cvzf $new_tarfile outref";
	} else {
		#        push @commands, "tar cvzf $new_tarfile opus* outref test_data"
		#	( 040119 - Jake - I am trying to separate the test_data and opus from outref dirs for all components )
		push @commands, "/bin/tar cf - outref | /bin/gzip > $new_tarfile.outref";
		#push @commands, "tar cvzf $new_tarfile.outref outref";
		push @commands, "/bin/tar cf - opus* test_data | /bin/gzip > $new_tarfile.testdataandopus";
		#push @commands, "tar cvzf $new_tarfile.testdataandopus opus* test_data";
		print "\n\n\n\n\n\n\n\n";
		print "      DO NOT FORGET TO MODIFY THIS PERL SCRIPT AND TO RENAME THE TEST DATA FILES FOR THIS PIPELINE NOW!\n";
		print "      You shouldn't have gotten here!  Unrecognized pipeline : $pipeline.  Will try to continue.";
		print "\n\n\n\n\n\n\n\n";
	}
	
	print ">> Current directory : ";
	print `pwd`;
	foreach $command (@commands) {
		print "$prefix Running:  $command\n" if ($debug);
		@result = `$command`;
		exit $? if ($?);
	} #end foreach command

} else {
	print "$prefix No differences;  not remaking tar file.\n";
}

########
# DONE.
########
print "$prefix DONE\n" if ($debug);
print "$prefix \n";
print "$prefix The following must now be done by hand:\n";
print "$prefix - examine the dircmp results, create the $analysis_file_name;\n";
print "$prefix - write protect the $version directory;\n";
print "$prefix - run gen_diff_page.pl;\n";
print "$prefix - if needed, send round an email to the relevant people.\n";
print "$prefix \n";
print "$prefix NEW * update README.test to read the new tar file $this_tar_version\n" if ( ($this_tar_version) && !($rename) );

exit;


sub byversion {
	#  Sorts things like 11.10 > 11.9 and 11.10.0 > 11.10
	#  
	
	my (@a) = split '\.', $a;
	my (@b) = split '\.', $b;
	my $i;
	my $max;
	if ($#a >= $#b) {$max = $#a;} else { $max = $#b;}
	
	for ($i = 0; $i <= $max; $i++) {
		if (defined($a[$i]) && defined($b[$i])) {
			if ($a[$i] > $b[$i]) { return 1;}
			if ($a[$i] < $b[$i]) { return -1;}
			if ($a[$i] == $b[$i]) { next;}
		}
		else {
			return 1 if (defined $a[$i]);
			return -1 if (defined $b[$i]);
		}
	}
	return 0;
}
