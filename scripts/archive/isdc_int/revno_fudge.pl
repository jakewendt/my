#! /bin/sh
eval '  exec perl -x $0 ${1+"$@"} '
#! perl
#
#####################################################################
#
#   Script to fudge REVOL keywords in Consolidated processing ahead of
#    SPR 2658 implementation.
#
#####################################################################
  use File::Basename;

my @revnos;
my $revno;
#################
#
#  These are the types which need keywords to be added or filled:
#
my %types = (
	     "aca/ibis_aca_cu" => "IBIS-UNIT-CAL",
	     "aca/ibis_aca_veto" => "IBIS-VETO-CAL",
	     "cfg/picsit_fault_list" => "PICS-FALT-STA",
	     "osm/spi_psd_adcgain" => "SPI.-ADC.-PSD",
	     "osm/spi_psd_efficiency" => "SPI.-EFFI-PSD",
	     "osm/spi_psd_performance" => "SPI.-PERF-PSD",
	     "osm/spi_psd_si" => "SPI.-SIGN-PSD",
	    );
#################
#
#  These are either indices which were missing the REVOL column or those
#    where it wasn't set in the children.  Either way, we need to remake them. 
#
my %idx_types = (
		 "aca/ibis_aca_cu" => "IBIS-UNIT-CAL",
		 "aca/ibis_aca_veto" => "IBIS-VETO-CAL",
		 "cfg/picsit_fault_list" => "PICS-FALT-STA",
		 "osm/spi_psd_adcgain" => "SPI.-ADC.-PSD",
		 "osm/spi_psd_efficiency" => "SPI.-EFFI-PSD",
		 "osm/spi_psd_performance" => "SPI.-PERF-PSD",
		 "osm/spi_psd_si" => "SPI.-SIGN-PSD",
		 "cfg/isgri_pxlswtch" => "ISGR-SWIT-STA",
		 "raw/picsit_raw_cal" => "PICS-CSI.-GRP",
		 "raw/jemx1_raw_frss" => "JMX1-FRSS-CRW",
		 "raw/jemx2_raw_frss" => "JMX2-FRSS-CRW",
	    );
#
#################
my $type;
my @files;
my $file;
my @result;
my $dol;
my $root;
my $subdir;
my $index;
my $template;

########
#  Read in command line args, if any:  
########
foreach (@ARGV) {
  if (/--h/) {
    print "\nUSAGE:  revno_fudge.pl [--h] <revno> <revno>....\n";
    print "\n\t(Uses REP_BASE_PROD variable.  Revnos must be four digits.)\n\n";
    exit;
  }
  else {
    $revno = $_;
    die ">>>>>>>     $revno is not a valid revolutution number\n" unless ($revno =~ /^\d{4}$/);
    push @revnos, $revno;
  }

}
print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
print ">>>>>>>     Fudging revolutions ".join(' ',@revnos)."\n";
print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";

################
#
#  Foreach revolution number given, do first the dal_attr then remake indices
#
################
foreach $revno (@revnos) {
  print "\n\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
  print ">>>>>>>     REVNO ${revno}\n";
  print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";

  die ">>>>>>>     ERROR:  Cannot find revno $revno in $ENV{REP_BASE_PROD}/scw/${revno}\n" unless (-w "$ENV{REP_BASE_PROD}/scw/${revno}");



  ################
  #  First dal_attr
  ################
  foreach $type (keys %types) {

      print "\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
      print ">>>>>>>     Type $type\n";
      print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";


    @files = `/usr/local/bin/ls $ENV{REP_BASE_PROD}/scw/${revno}/rev.000/${type}*fits 2> /dev/null`;
    print ">>>>>>>    WARNING:  didn't find anything of type $type for rev ${revno};  @files\n" if ($?);

    print ">>>>>>>     Found these files of type $type to fudge for revolution ${revno}:\n".join("\n",@files)."\n" if (@files);


    foreach $file (@files) {

      chomp $file;
      #  Make it writable:
      print ">>>>>>>     RUNNING:  \'/usr/local/bin/chmod +w $file\'\n";
      @result = `/usr/local/bin/chmod +w $file`;
      die ">>>>>>>     ERROR:  cannot \'/usr/local/bin/chmod +w $file\':@result\n" if ($?);

      $dol = $file."[$types{$type}]";

      #  Run dal_attr:
      print ">>>>>>>     RUNNING:  \'dal_attr  action=WRITE comment=\"Revolution number (set by pipeline)\" indol=${dol} keynam=REVOL type=DAL_INT unit= value_b= value_ci=0.0 value_cr=0.0 value_i=${revno} value_r= value_s=\'\n";
      @result = `dal_attr  action=WRITE comment=\"Revolution number (set by pipeline)\" indol=${dol} keynam=REVOL type=DAL_INT unit= value_b= value_ci=0.0 value_cr=0.0 value_i=${revno} value_r= value_s=`;
      
      die ">>>>>>>     ERROR:  cannot \'dal_attr  action=WRITE comment=\"Revolution number (set by pipeline)\" indol=${dol} keynam=REVOL type=DAL_INT unit= value_b= value_ci=0.0 value_cr=0.0 value_i=${revno} value_r= value_s=\':@result\n" if ($?);
      

      #  Make it un-writable:
      print ">>>>>>>     RUNNING:  \'/usr/local/bin/chmod -w $file\'\n";
      @result = `/usr/local/bin/chmod -w $file`;
      die ">>>>>>>     ERROR:  cannot \'/usr/local/bin/chmod -w $file\':@result\n" if ($?);


    } #  foreach file


  } # foreach type


  ################
  #  Now remake indices
  ################
  chdir "$ENV{REP_BASE_PROD}/scw/${revno}/rev.000/idx/" or die ">>>>>>>     ERROR:  cannot chdir to $ENV{REP_BASE_PROD}/scw/${revno}/rev.000/idx/\n";
  print ">>>>>>>     Current dir is $ENV{REP_BASE_PROD}/scw/${revno}/rev.000/idx/\n";

  if (!-w "$ENV{REP_BASE_PROD}/scw/${revno}/rev.000/idx") {
    print ">>>>>>>     RUNNING:  \'/usr/local/bin/chmod +w $ENV{REP_BASE_PROD}/scw/${revno}/rev.000/idx/\'\n";
    `/usr/local/bin/chmod +w $ENV{REP_BASE_PROD}/scw/${revno}/rev.000/idx`;
    die ">>>>>>>     ERROR:  couldn't \'/usr/local/bin/chmod +w $ENV{REP_BASE_PROD}/scw/${revno}/rev.000/idx\'\n" if ($?);
  } # if idx dir not writable

  foreach $type (keys %idx_types) {

    print "\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
    print ">>>>>>>     Index type $type\n";
    print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";

    $root = basename $type;
    $subdir = dirname $type;


    @files = `/usr/local/bin/ls ${root}_index.fits 2> /dev/null`; 
    if (@files) {
      $index = $files[$#files];
      chomp $index;
      print ">>>>>>>     Found index $index to remake.\n";

      print ">>>>>>>     RUNNING:  \'/usr/local/bin/mv $index ${index}.bak\'\n";
      `/usr/local/bin/mv $index ${index}.bak`;
      die ">>>>>>>     ERROR:  couldn't \'/usr/local/bin/mv $index ${index}.bak\'\n" if ($?);

      $template = $idx_types{$type}."-IDX.tpl";
      print ">>>>>>>     RUNNING:  \'dal_create obj_name=$index template=${template}\'\n";
      `dal_create obj_name=$index template=${template}`;
      die ">>>>>>>     ERROR:  couldn't \'dal_create obj_name=$index template=${template}\'\n" if ($?);

      $index = $index."[GROUPING]";
      
      #  remember $type has subdir in it
      @files = `/usr/local/bin/ls ../${type}*fits 2> /dev/null`;
      die ">>>>>>>    ERROR:  Got index for type $type but didn't find any children!  @files\n" if ($?);
      
      foreach $file (@files) {
	chomp $file;
	$file = "$file"."[$idx_types{$type}]" unless ($idx_types{$type} =~ /GRP$/);
	$file = "$file"."[GROUPING]" if ($idx_types{$type} =~ /GRP$/);
	print ">>>>>>>     RUNNING:  \'idx_add  element=$file  index=$index security=0 sort= sortOrder=1 sortType=1 stamp=0 template= update=1\'\n";
	`idx_add  element=$file  index=$index security=0 sort= sortOrder=1 sortType=1 stamp=0 template= update=1`;
	die ">>>>>>>     ERROR:  couldn't \'idx_add  element=$file  index=$index security=0 sort= sortOrder=1 sortType=1 stamp=0 template= update=1\'\n" if ($?); 
	
      } # end foreach child of this type
      

      #  Remove the backup we made.
      $index =~ s/\[GROUPING\]//;
      print ">>>>>>>     Unlinking ${index}.bak\n";
      unlink "${index}.bak" or die ">>>>>>>     ERROR:  cannot unlink ${index}.bak\n";



    } # if didn't find this type index 
    else {
      print ">>>>>>>     WARNING:  didn't find $root index to remake.\n";
      next;
    }
    
    
  }  # end foreach idx_types

  print ">>>>>>>     RUNNING \'/usr/local/bin/chmod -R -w -R $ENV{REP_BASE_PROD}/scw/${revno}/rev.000\'\n";
  `/usr/local/bin/chmod -R -w -R $ENV{REP_BASE_PROD}/scw/${revno}/rev.000`;
  die ">>>>>>>     ERROR:  couldn't \'/usr/local/bin/chmod -R -w -R $ENV{REP_BASE_PROD}/scw/${revno}/rev.000\'\n" if ($?); 

} # end foreach revno


print "\n\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
print ">>>>>>>     Done.\n"; 
print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
exit; 

