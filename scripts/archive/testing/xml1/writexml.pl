#!/usr/bin/perl

use lib "/unsaved_data/wendt/rsync/my/lib/";
use XML::Simple;

my %hsh;

$hsh{'A'}{'name'} = "Test name";
$hsh{'A'}{'id'} = "Test id";
$hsh{'A'}{'text1'} = "Each scheme will be tried in turn in the hope of finding a cached pre-parsed representation of the XML file. If no cached copy is found, the file will be parsed and the first cache scheme in the list will be used to save a copy of the results. The following cache schemes have been implemented:";
$hsh{'A'}{'text2'} = "Each scheme will be tried in turn in the hope of finding a cached pre-parsed representation of the XML file. If no cached copy is found, the file will be parsed and the first cache scheme in the list will be used to save a copy of the results. The following cache schemes have been implemented:";

$hsh{'B'}{'name'} = "Test name";
$hsh{'B'}{'id'} = "Test id";
$hsh{'B'}{'text'} = "Each scheme will be tried in turn in the hope of finding a cached pre-parsed representation of the XML file. If no cached copy is found, the file will be parsed and the first cache scheme in the list will be used to save a copy of the results. The following cache schemes have been implemented:Test id";
$hsh{'B'}{'arr'} = [ qw/This is a test array/ ];

my $xml = XMLout(\%hsh);

open XML, "> test.xml";
print XML "$xml\n";
close XML;
