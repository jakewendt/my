#!/isdc/sw/perl/5.6.0/WS/prod/bin/perl -w
#
#  Little script to create web page to navigate regression directories.

use File::Basename;

#  Default input and output locations:
my $outfile = "/home/isdc_guest/isdc_int/WWW/IntDiffs.html";
my $indir =  "/home/isdc_guest/isdc_int/regression/";

#  Default contents of each version subdir:
my $version_file_name = "VERSION";
my $analysis_file_name = "dircmp.analysis";
my $env_file_name = "env_dump.txt";
my $sdiff_file_name = "integration.sdiff";
my $integration_file_name = "integration.txt";
my $diffFileAll_name = "tmp_isdc_dircmp/diffFileAll.log";
my $dircmp_out_name = "tmp_isdc_dircmp/isdc_dircmp.out";
my $debug_info_name = "debug.html";
my $flag_file_name = "flag.html";
my $width = "120";
my $dwidth = "100";
my $fwidth = "30";
my $vwidth = "100";
my $border = "0";

my @pipelines;
my $pipeline;
my $htmlhead = "<html><head><title>ISDC Integration Differences</title>\n<body><center><h1>ISDC Integration Summary of Data Differences</h1></center>\n<p>\n<B><a href=regression/README>README</a></B>:  information about the contents of this page.\n<p>\n";

my $htmlhead2 .= "<hr noshade=><hr noshade=><p><table><td width=50><b>Flag</td><td width=${vwidth}><b>Version<br><small>(link to sw diff)</small></td><td width=${dwidth}><b>Date</td><td width=${width}><b>Analysis of differences</td><td width=${width}><b>VERSION file</td><td width=${width}><b>Integration Report</td><td width=${width}><b>Debugging Info</td> </table>";

$htmlhead2 .= "(The flags: 0 - no differences; <image src=question.gif width=20> - differences to be investigated;  <image src=check.gif width=20> - differences OK.)\n";

my $htmltail = "<p><hr><a href=IntDiffsSVTE-E2E.html>Click here for the older regression area where SVT-E E2E data was used.</a></body></html>\n";
#my $htmltail = "</body></html>\n";
my @versions;
my $version;
my $basevers;
my $subvers;
my $file;
my $line;
my $entry;
my $suffix;
my $subdir;
my $date;
my $flag;

########
#  Read in command line args, if any:  
########
foreach (@ARGV) {
	if (/--h/) {
		print "\nUSAGE:  gen_diff_page.pl [--h] [--outfile=] [--indir=]\n\nwhere default outfile is $outfile and default indir is $indir.  This script will read the indir, and for each pipeline subdir, generate a table of links to the VERSION files, isdc_dircmp results, analysis, etc.\n\n";
		exit;
	}
	elsif (/--debug/) {
		$debug++;
		print ">>>>>>>     gen_diff_page.pl running in debug mode.\n";
	}
	elsif (/--outfile=(.*)$/) {
		$outfile = $1;
		print ">>>>>>>     Writing to outfile $outfile\n" if ($debug);
	}
	elsif (/--indir=(.*)$/) {
		$indir = $1;
		print ">>>>>>>     Reading from indir $indir\n" if ($debug);
	}
	elsif (/--dif/) {		#	only generate entries for those with differences (flag.html exists) + most recent
		$diffs_only++;
		print ">>>>>>>     gen_diff_page.pl running in diffs_only mode.\n";
	}
	elsif (/--q/) {		#	only generate entries for those with unapproved diffs (flag.html size = 60) + most recent
		$quests_only++;
		print ">>>>>>>     gen_diff_page.pl running in questions_only mode.\n";
	}
} 

$htmlhead .= "Skip to:  <b>";

#  Read in the set of pipelines based on contents of $indir:
opendir (TOP,"$indir") or die ">>>>>>>     ERROR:  cannot open $indir to read!\n";
#  Read directory contents, excluding ".*".  Note that the results
#   are only the entries without the path.
@pipelines = sort grep !/^\./, readdir TOP;
closedir TOP;

$htmlhead .= "<table border=0><tr>";
foreach (@pipelines) {   
	next unless (-d "${indir}/${_}");
	$htmlhead .= "<td width=100><a href=\"\#${_}\">${_}</a></td>";
}
$htmlhead .= "</tr></table></b><p>";

########
#  Start output HTML file:
########
if (-e "$outfile") {
	print ">>>>>>>     Moving $outfile to .bak\n";
	`mv $outfile ${outfile}.bak`;
}
open (OUT,">$outfile") or die ">>>>>>>     ERROR:  cannot open $outfile to write!\n";

print OUT $htmlhead;
print OUT $htmlhead2;

########
#  Loop over pipeline subdirs:
########
foreach $pipeline (@pipelines) {
	next unless (-d "${indir}/${pipeline}");
	next if ($pipeline =~ /svt/);
	print ">>>>>>>     Found pipeline $pipeline;  looking for versions.\n" if ($debug);
	opendir (DIR,"${indir}/${pipeline}") or die ">>>>>>>     ERROR:  cannot open directory ${indir}/${pipeline} to read!\n";
	@versions = sort grep !/^\./, readdir DIR;
	close DIR;
	
	#  Begin HTML table for this pipeline:
	print OUT "\n<p><a id=${pipeline}></a><hr>\n<big>${pipeline}</big>\n<table border=${border}>\n";
	
	########
	#  Loop over version subdirs, sorted in descending order:
	########
	my $newestversion = 1;

	foreach $version (sort byversionreverse @versions) {
		print ">>>>>>>     Found $pipeline version $version.\n" if ($debug);
		
		next unless ($version =~ /^(\d+\.\d+)\.?(\d*)$/);
		$basevers = $1;
		$subvers = $2 if ($2);
		print ">>>>>>>     Base version $basevers, sub version $subvers\n" if ($debug);
		
		#	040607 - Jake - added to make the page smaller, yet saving all the precious data. Filter out "0"s
		next if ( ( ! -e "${indir}/${pipeline}/${version}/flag.html" ) && ( $quests_only || $diffs_only ) && ( ! $newestversion ) );

		#	040614 - Jake - added to make the page even smaller.  Filter out check flags
		my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) 
			= stat ( "${indir}/${pipeline}/${version}/flag.html" ) if ( -e "${indir}/${pipeline}/${version}/flag.html" );
		next if ( ( -e "${indir}/${pipeline}/${version}/flag.html" ) && ( $quests_only ) && ( $size == 45 ) && ( ! $newestversion ) );

		$newestversion = 0;

		#  Start the row
		print OUT "<tr>\n";
		
		#  Check for flags:
		if (-e "${indir}/${pipeline}/${version}/${flag_file_name}") {
			$flag = `cat ${indir}/${pipeline}/${version}/${flag_file_name}`;
			chomp $flag;
			print OUT "<td width=${fwidth}>${flag}</td>";
		} # if flags
		else {
			print OUT "<td width=${fwidth}><a href=zero.html>0</a></td>";
		}
		
		#  The version column:
		print OUT "<td width=${vwidth}><B><a href=regression/${pipeline}/${version}/change>${version}</a></B></td>";
		
		#  Get the date:
		if (-e "${indir}/${pipeline}/${version}/date") {
			$date = `cat ${indir}/${pipeline}/${version}/date`;
			chomp $date;
			# date returns, e.g. "Mon Jul 29 11:56:26 MEST 2002" or MET!
			$date =~ /^\w{3}\s(\w{3})\s+(\d+)\s\S+\sMES?T\s(\d{4})/;
			# Change to "2002 Jul 29";
			$date = "$3 $1 $2";
			print OUT "<td width=${dwidth}>${date}</td>";
		}
		else {
			print ">>>>>>>     WARNING:  didn't find date file ${indir}/${pipeline}/${version}/date\n" if ($debug);
			print OUT "<td></td>";
		}
		
		#  Check for minimum contents:
		foreach ( $analysis_file_name,  $version_file_name, $integration_file_name, $debug_info_name ) {
			#  Use $file instead of $_ because want to modify it without modifying
			#   the constant file names.
			$file = $_;
			if (-e "${indir}/${pipeline}/${version}/${file}") {
				print ">>>>>>>     Found $pipeline version $version file $file\n" if ($debug);
				#  write entry for this column:
				#  (note annoying way to remove tmp_isdc_dircmp/ from HTML but 
				#   include it in link.  blech.
				$link = "regression/${pipeline}/${version}/$file";
				($entry,$subdir,$suffix) = File::Basename::fileparse($file,'\..*');
				print OUT "<td width=${width}><a href=${link}>${entry}${suffix}</a></td>";
				
			}
			else {
				print ">>>>>>>     WARNING:  didn't find ${indir}/${pipeline}/${version}/${file}\n" unless ( ${file} =~ /dircmp\.analysis/ );
				print OUT "<td></td>";
			}
		} # end foreach expected file 
		
		print OUT "</tr>\n";
		
	}# end foreach version
	
	print OUT "</table>\n\n";
	
} # end foreach pipeline


########
#  Finish HTML file:
########
print OUT $htmltail;
close OUT;

########
# DONE.
########
print ">>>>>>>     DONE\n" if ($debug);
exit;



sub byversionreverse {
	#  Sorts things like 11.10 > 11.9 and 11.10.0 > 11.10
	#  
	
	my $mya = basename $a;
	my $myb = basename $b;
	
	my (@a) = split '\.', $mya;
	my (@b) = split '\.', $myb;
	my $i;
	my $max;
	if ($#a >= $#b) {$max = $#a;} else { $max = $#b;}
	
	for ($i = 0; $i <= $max; $i++) {
		if (defined($a[$i]) && defined($b[$i])) {
			if ($a[$i] < $b[$i]) { return 1;}
			if ($a[$i] > $b[$i]) { return -1;}
			if ($a[$i] == $b[$i]) { next;}
		}
		else {
			return -1 if (defined $a[$i]);
			return 1 if (defined $b[$i]);
		}
	}
	return 0;
}
