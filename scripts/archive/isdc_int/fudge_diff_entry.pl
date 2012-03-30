#!/isdc/sw/perl/5.6.0/WS/prod/bin/perl -w
use File::Basename;

#  Default input and output locations:
my $topdir =  "/home/isdc_guest/isdc_int/regression/";

#  Default contents of each version subdir:
my $version_file_name = "VERSION";
my $analysis_file_name = "dircmp.analysis";
my $env_file_name = "env_dump.txt";
my $integration_file_name = "integration.txt";
my $diffFileAll_name = "tmp_isdc_dircmp/diffFileAll.log";
my $dircmp_out_name = "tmp_isdc_dircmp/isdc_dircmp.out";
my $debug_info_name = "debug.html";
my $flag_file_name = "flag.html";

my $pipeline;
my @versions;
my @integrations;
my $version;
my $date;
my @commands;
my $command;
my @result;
my $debug = 1;


foreach $pipeline (glob("$topdir/*")) {
#foreach $pipeline ("$topdir/adp") {
  $pipeline = File::Basename::fileparse($pipeline,'');
  next unless ($pipeline =~ /^adp|nrt/);
  print "Got pipeline $pipeline\n";
  foreach $version (glob("${topdir}/${pipeline}/*")) {
    $version = File::Basename::fileparse($version,'');

    print "Got version $version\n";
    next unless (-e "${topdir}/${pipeline}/${version}/${flag_file_name}");

    rename "${topdir}/${pipeline}/${version}/${flag_file_name}", "${topdir}/${pipeline}/${version}/${flag_file_name}".".old" or die "*******     ERROR:  cannot rename ${topdir}/${pipeline}/${version}/${flag_file_name} to ${topdir}/${pipeline}/${version}/${flag_file_name}".".old";
    
    if (`grep question ${topdir}/${pipeline}/${version}/${flag_file_name}.old`) {
      `cp $ENV{HOME}/WWW/question_flag.html ${topdir}/${pipeline}/${version}/${flag_file_name}`;
      die "*******     ERROR:  cannot cp $ENV{HOME}/WWW/question_flag.html ${topdir}/${pipeline}/${version}/${flag_file_name}\n" if ($?);
    }
    elsif (`grep check ${topdir}/${pipeline}/${version}/${flag_file_name}.old`) {
	`cp $ENV{HOME}/WWW/check_flag.html ${topdir}/${pipeline}/${version}/${flag_file_name}`;
	die "*******     ERROR:  cannot cp $ENV{HOME}/WWW/check_flag.html ${topdir}/${pipeline}/${version}/${flag_file_name}\n" if ($?);
      }
    else {
      print "what's this?\n";
      print `cat ${topdir}/${pipeline}/${version}/${flag_file_name}.old`;
      die;
    }

  }  # end foreach version
} # end foreach pipeline

exit;
