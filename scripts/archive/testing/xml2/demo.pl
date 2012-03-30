#!/usr/bin/perl

use lib "/unsaved_data/wendt/rsync/my/lib/";
use XML::Dumper;
my $dump = new XML::Dumper;

my $perl  = '';
my $xml   = '';

# ===== Convert Perl code to XML
$perl = [
  {
              fname       => 'Fred',
              lname       => 'Flintstone',
              residence   => 'Bedrock'
  },
  {
              fname       => 'Barney',
              lname       => 'Rubble',
              residence   => 'Bedrock'
  }
];
$xml = $dump->pl2xml( $perl );
print "$xml\n";

# ===== Dump to a file
my $file = "dump.xml";
$dump->pl2xml( $perl, $file );

# ===== Convert XML to Perl code
$xml = q|
<perldata>
 <arrayref>
  <item key="0">
   <hashref>
      <item key="fname">Fred</item>
      <item key="lname">Flintstone</item>
      <item key="residence">Bedrock</item>
   </hashref>
  </item>
  <item key="1">
   <hashref>
      <item key="fname">Barney</item>
      <item key="lname">Rubble</item>
      <item key="residence">Bedrock</item>
   </hashref>
  </item>
 </arrayref>
</perldata>
|;


my $perl = $dump->xml2pl( $xml );	#	returns a reference to an array (which contains references to hashes)

# ===== Convert an XML file to Perl code
my $perl = $dump->xml2pl( $file );

# ===== And serialize Perl code to an XML file
$dump->pl2xml( $perl, $file );

#	# ===== USE COMPRESSION
#	#$dump->pl2xml( $perl, $file.".gz" );

#	# ===== INCLUDE AN IN-DOCUMENT DTD
#	$dump->dtd;
#	my $xml_with_dtd = $dump->pl2xml( $perl );
#	
# ===== USE EXTERNAL DTD
#	$dump->dtd( $file, $url );
#	my $xml_with_link_to_dtd = $dump->pl2xml( $perl );
