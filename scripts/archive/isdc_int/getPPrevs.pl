#!/isdc/sw/perl/5.6.0/WS/prod/bin/perl -w

use lib "$ENV{ISDC_OPUS}/nrtrev/";
use Datasets; 

if ($ARGV[0] eq "--h") {
  print "\nUSAGE:  getPPrevs.pl [path 2 PP code dir]\nIf no parameter given, PP code found through ISDC_ENV.  But ISDC_OPUS must be defined and contain nrtrev/Datasets.pm.\n\n";
  exit;
}
elsif (-d "$ARGV[0]") {
  $PPpath = $ARGV[0];
}
else {
  $PPpath = "$ENV{ISDC_ENV}/sys-sw/pp/Preproc/";
  die "ERROR:  cannot find $PPpath.\n" unless (-d "$PPpath");

}
#  Grep through PP parsers for trigger and file names.  This depends, of 
#   course, on PP using a consistent syntax everywhere.  Got a better idea?
#   The syntax was developed empirically.  
#
#  Now, in theory, when we do this grep, we get out the types and the files
#   in the same order.  Don't mess with the order!
#

print "Searching and cross-checking....\n";

#  Changed to case insensitive becaue m_fileName for most but m_pdfFileName
#   for e.g. SPI case.  Or m_acsFileName, or m_dfFileName....
$command = 'grep -i filename '.$PPpath.'/parsers/* | awk -F= \'/\=/ && ! /new/{print $2}\'';
@files = `$command`;

$command =~ s/file/trigger/;
@types = `$command`;

#  Nothing we can do if they don't match up: 
die "ERROR:  $#types types and $#files files!\n" if ($#types != $#files );

# THIS DOESN'T WORK:  unfortunately, some are found repeatedly.
#  Check the number ISDC_OPUS/nrtrev/Datasets.pm knows about:
#if (scalar(keys(%Datasets::Types)) != scalar(@types)) {
#  print "WARNING:  number of types defined in OPUS Datasets.pm is ".scalar(keys(%Datasets::Types))." while number found in PP is ".scalar(@types)."\n";
#}

# Now, that grep/awk result looks like this:
#
# "ire";
#         or
#
# "irem_raw";
#

#  First, loop through types and check for current OPUS definition:
# 

for ($i = 0; $i <= $#types; $i++) {
  chomp $types[$i];
  chomp $files[$i];
  $types[$i] =~ s/\s|\"|;//g;
  $files[$i] =~ s/\s|\"|;//g;
  # Create hash for PP's entries, like OPUS's Datasets::Types:
  $PPhash{$types[$i]} = $files[$i];

  #  Now compare PPhash with Datasets
  if (defined($Datasets::Types{$types[$i]})) {
    
    print "Type $types[$i] defined as $PPhash{$types[$i]} in both\n" if ($PPhash{$types[$i]} eq $Datasets::Types{$types[$i]});
    print "WARNING:  type $types[$i] defined as $PPhash{$types[$i]} in PP and as $Datasets::Types{$types[$i]} in OPUS Datasets.pm\n" if ($PPhash{$types[$i]} ne $Datasets::Types{$types[$i]});
    
  }
  else {
    print "WARNING:  type $types[$i] not defined in OPUS Datasets.pm\n";
  }
  
}

# Lastly, go through other way, i.e. see if all Datasets entries defined in PP
#
foreach (keys(%Datasets::Types)) {
  print "WARNING:  type $_ from Datasets not found in PP!\n" unless (defined($PPhash{$_}));
}  

print "Done\n";
exit;
