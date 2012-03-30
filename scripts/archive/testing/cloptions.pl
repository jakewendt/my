#!/usr/bin/perl -w

my ($obsid,$object,$split,$inst,$purpose,$purpose_master);
my @instruments;
my $ao;
my $in;
my $command;
my ($retval,@result);
my $time;

foreach (@ARGV) {
   if (/--h/) {
      print "\nUSAGE:  sa_start.pl obsid= [object=] [split=] [instrument=] [purpose=]\n\n";
      print "\tDefault split is 001, instrument={IBIS,SPI,OMC,JMX2}, purpose=\"INST SA for AOn Obs. Object\", where og_create is called separately for each in
strument.  Currently, putting multiple instruments in one OG is not supported.\n\n";
      exit;
   }
   elsif (/^obsid=(.*)$/) {
      $obsid = $1;
   }
   elsif (/^object=(.*)$/) {
      $object = $1;
   }
   elsif (/^split=(.*)$/) {
      $split = $1;
   }
   elsif (/^instrument=(.*)$/) {
      $inst = $1;
      $inst =~ tr/a-z/A-Z/;
   }
   elsif (/^purpose=(.*)$/) {
      $purpose = $1;
   }

}

print "$inst\n\n";

if ($inst) {
	@instruments=split ( ",", $inst );
	foreach ( @instruments ) {
   	die ">>>>>>>     ERROR:  instrument must be IBIS, JMX1, JMX2, SPI, or OMC.  You specified $inst\n" if ($_ !~ /^(ibis|jmx1|jmx2|spi|omc)$/i);
		print "$_\n";
	}
}



