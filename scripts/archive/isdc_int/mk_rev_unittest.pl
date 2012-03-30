#!/isdc/sw/bin/perl -w

use Datasets;
use File::Basename;
my $stream = "nrt";
if (defined(@ARGV) && ($ARGV[0] =~ /--h/)) {
  print "USAGE:  mk_rev_unittest.pl\n\nwhere \$ISDC_OPUS/nrtrev/unit_test/opus_work/nrtrev/input/ contains the triggers desired and \$REP_BASE_PROD the new data.  Puts results in $ISDC_OPUS/nrtrev/unit_test/test_data.new.\n";
  exit;
}

if (defined(@ARGV) && ($ARGV[0] =~ /--cons/)) {
  $stream = "cons";
}

@triggers = glob("$ENV{ISDC_OPUS}/${stream}rev/unit_test/opus_work/${stream}rev/input/*");

foreach $trigger (@triggers) {
  ($root,$path,$suffix) = File::Basename::fileparse($trigger,'\..*');
  ($dataset,$type,$revno,$prevrev,$nextrev,$use) = Datasets::RevDataset($root);
  `mkdir -p $ENV{ISDC_OPUS}/${stream}rev/unit_test/test_data.new/scw/${revno}/rev.000/raw` unless (-e "$ENV{ISDC_OPUS}/${stream}rev/unit_test/test_data.new/scw/${revno}/rev.000/raw");
  die "ERROR:  cannot \'mkdir -p $ENV{ISDC_OPUS}/${stream}rev/unit_test/test_data.new/scw/${revno}/rev.000/raw\'\n" if ($?);
 
  if (-e "$ENV{REP_BASE_PROD}/scw/${revno}/rev.000/raw/${dataset}") { 

    `cp $ENV{REP_BASE_PROD}/scw/${revno}/rev.000/raw/${dataset} $ENV{ISDC_OPUS}/${stream}rev/unit_test/test_data.new/scw/${revno}/rev.000/raw`; 
    die "ERROR:  cannot \'cp $ENV{REP_BASE_PROD}/${revno}/rev.000/raw/${dataset} $ENV{ISDC_OPUS}/${stream}rev/unit_test/test_data.new/scw/${revno}/rev.000/raw\'\n" if ($?);
    print "COPIED:  file ${dataset} successfully copied.\n";
  }
  else {
    print "WARNING:  file ${dataset} not found;  continuing.\n";
  }

}
print "Done.\n";
exit;

