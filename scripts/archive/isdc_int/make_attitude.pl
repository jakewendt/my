#! /usr/bin/perl -w

use strict;
use File::Basename;

if (!@ARGV) {
  print "\n\tUSAGE:  make_attitude.pl <directory> <attitude> <output> <HIS|PRE> \n\n   where <directory> contains the science windows for which you want attitude entries; \n   <attitude> is an ASCII file with the one line attitude entry you want used for the result;\n   <output> is the output attitude FITS file;  <HIS|PRE> is the type of attitude file you want,\n   HIS==historic, PRE=predicted.\n";
  print "\n\tWARNING:  this only works well on the Office network.  For unknowns reasons, the Ops net result is incomplete;  fcreate randomly stops without processing all the data.  Run the script on the Ops net if you need to create the input there.  Take the out.tmp etc. over to the Office net and repeate the fcreate command (which will be printed for you to cut and paste.)\n";
  exit;
}

my $dir = $ARGV[0];
my $att_line_file = $ARGV[1];
my $outfile = $ARGV[2];
my $att_type = $ARGV[3];

die "*******     ERROR:  don't recognize type $att_type\n" if ($att_type !~ /HIS|PRP/);

my $scwid;
my @scwids;
my ($root,$path,$suffix);
my $pid;
my %pids;
my $i;
my @att_line;
my $new_att_line;
my @columns;
my @format;
my @units;
my @result;
my $count;

open(LINE,"${att_line_file}") or die "*******     ERROR:  cannot find input attitude line at $att_line_file\n";
while(<LINE>) {  
  chomp; 
  next unless (/\w+/); 
  s/^\s+//g;
  #  Because fv doesn't dump to text good input to fcreate (!)
  s/NULL/INDEF/g;
  # first line is column names
  @columns = split('\s+') if (/^\s*POINTING/);
  # next is format (data type)
  @format = split('\s+') if (/^\s*8A/);
  # next is units
#  @units = split('\s+') if (/^\s*s\s+/);
  # lastly values
  @att_line = split('\s+') if (/^\s*\d{8}/); 
}

open(COL,">colfile.tmp") or die "*******     ERROR:  cannot find column def file colfile.tmp\n";

for ($i = 0; $i <= $#columns; $i++) {
  print COL "$columns[$i] $format[$i] \n";
}
close (COL);


@scwids = `ls $dir`; 

die "*******     ERROR:  can't find science windows at $dir\n" unless (@scwids);


###
#   Create a text file with a line for each pointing ID
###

foreach $scwid (@scwids) {  
  
  ($root,$path,$suffix) = File::Basename::fileparse($scwid, '\..*');

  next unless ($root =~ /^(\d{8})\d{4}$/);
  $pids{$1}++;
  $count++;
}


open(TMP,">out.tmp") or die "*******    ERROR:  cannot open out.tmp to write.\n";


foreach $pid (sort(keys(%pids))) {
  #  This is fudged to work with my current dummy attitude file and how
  #   fv dumps it to txt (i.e. with some blank entries which have to be filled
  #   for fcreate to work);  may need to be updated.
  #                PID  PTYPE       SRC_ID ATT_SEQ      SLEW_TIME    POINTING_TIME
  $new_att_line = "$pid $att_line[1] INDEF $att_line[2] $att_line[3] $att_line[4] ";
  #                TIME          DURATION     OTF_THR      RA_SCX       DEC_SCX
  $new_att_line .= "$att_line[5] $att_line[6] $att_line[7] $att_line[8] $att_line[9] ";
  #                RA_SCZ        DEC_SCZ    STAR_NUM  RA_STAR    DEC_STAR 
  $new_att_line .= "$att_line[10] $att_line[11] INDEF $att_line[12] $att_line[13] ";
  #                   SUN_ASPECT   CONTINGENCY   APD_AMP         RA_DIFF      DEC_DIFF
  $new_att_line .= "$att_line[14] $att_line[15] $att_line[16] $att_line[17] $att_line[18]\n";

  print TMP $new_att_line;
  $count++;
  #  TO BE FIXED:  why does fcreate quit after some random number of rows
  #    around 112 or something?!
#  last if ($count > 99);

}

#  Now, we have everything for the fcreate call:
#unlink "$outfile" if (-e "$outfile");
print "*******     Running:  \' fcreate cdfile=colfile.tmp datafile=out.tmp outfile=$outfile extname=AUXL-ATTI-${att_type} clobber=yes\'\n";
@result = `fcreate cdfile=colfile.tmp datafile=out.tmp outfile=$outfile extname=AUXL-ATTI-${att_type} clobber=yes`;
die "*******     ERROR:  cannot run \'fcreate cdfile=colfile.tmp datafile=out.tmp outfile=$outfile extname=AUXL-ATTI-${att_type} clobber=yes\':\n@result\n" if ($?);  

#unlink "colfile.tmp";
#unlink "out.tmp";


unlink "keyfile.tmp" if (-e "keyfile.tmp");
#  Note:  none of this works!
open(KEYS,">keyfile.tmp") or die "*******    ERROR:  cannot open keyfile.tmp to write.\n";
for ($i=1; $i<=21; $i++) {
  print KEYS "TUNIT$i\n";
}
print KEYS "!GRP\n";
print KEYS "!EXTNAME\n";
close(KEYS);

#  Copy header keywords from the dummy:
print "*******     Running:  \'cphead $ENV{REP_BASE_PROD}/aux/adp/0000.000/attitude_predicted_00.fits+1 ${outfile}+1 keyfil=keyfile.tmp comment=no history=no\'\n";
die "*******     ERROR:  cannot find $ENV{REP_BASE_PROD}/aux/adp/0000.000/attitude_predicted_00.fits\n" if (!-e "$ENV{REP_BASE_PROD}/aux/adp/0000.000/attitude_predicted_00.fits");
@result = `cphead $ENV{REP_BASE_PROD}/aux/adp/0000.000/attitude_predicted_00.fits+1 ${outfile}+1 keyfil=keyfile.tmp comment=no history=no`;
die "*******     ERROR:  cannot run \'cphead $ENV{REP_BASE_PROD}/aux/adp/0000.000/attitude_predicted_00.fits+1 ${outfile}+1 keyfil=keyfile.tmp comment=no history=no\':\n@result\n" if ($?);

#unlink "keyfile.tmp";
print "*******     Done.\n";

exit;
