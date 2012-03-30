
use strict;
use URI::Escape qw/uri_escape/;
use POSIX;

package Source;

my @isdc_classes = (
	['10..', 'X-ray binary'],
	['1[1-3]..', 'High Mass X-ray Binary'],
	['1[4-5]..', 'Low Mass X-ray Binary'],
	['16..', 'CV'],
	['17..', 'Soft Gamma-ray Repeater'],
	['3...', 'Super-Novae Remnant'],
	['7000', 'Active Galactic Nuclei'],
	['7200', 'Quasi Stellar Object'],
	['7300', 'BL Lacertae'],
	['7800', 'Narrow Emmission Line Galaxy ']
);

my @all_classes = (
	['10..', 'X-ray binary'],
	['1[123]..', 'HMXRB'],
		['12..', ' supergiant'],
		['13..', ' Be star'],
	['1[45]..', 'LMXRB'],
		['15..', ' Globular cluster'],
			['1[1-5]1.', ' X-ray pulsar'],
			['1[1-5]2.', ' burster'],
			['1[1-5]3.', ' black hole'],
			['1[1-5]4.', ' QPO'],
			['1[1-5]5.', ' QPO & black hole'],
			['1[1-5]6.', ' QPO & pulsar'],
			['1[1-5]7.', ' QPO & bursts'],
			['1[1-5]8.', ' QPO,pulsar,bursts'],
			['1[1-5]9.', ' pulsar & bursts'],
				['1[1-5][1-9]1', ' flares'],
				['1[1-5][1-9]2', ' jets'],
				['1[1-5][1-9]3', ' eclipsing'],
				['1[1-5][1-9]4', ' ultra-soft transient'],
				['1[1-5][1-9]5', ' soft transient'],
				['1[1-5][1-9]6', ' hard transient'],
				['1[1-5][1-9]7', ' eclipsing dipper'],
				['1[1-5][1-9]8', ' eclipsing ADC'],
				['1[1-5][1-9]9', ' dipper'],

	['16..', 'CV'],
		['161.', ' Classical Nova'],
		['162.', ' Recurrent Nova'],
		['163.', ' AM Her (polar)'],
		['164.', ' Intermediate polar'],
		['165.', ' Dwarf nova'],
		['166.', ' Dwarf nova U Gem type'],
		['167.', ' Dwarf Nova Z Cam type'],
		['168.', ' Dwarf Nova SU Uma type'],
		['169.', ' Nova like'],
			['16.1', ' oscillations'],
			['16.2', ' coherent osc.'],
			['16.3', ' fast'],
			['16.4', ' slow'],
			['16.5', ' eclipsing'],

	['17..', 'Gamma ray'],
		['170.', ' source'],
		['171.', ' burst'],
		['172.', ' burst, soft repeater'],
			['17.1', ' pulsar'],

	['1800', 'Radio Pulsar'],
	['1810', 'X-ray pulsator'],
	['1820', 'Supersoft source'],
	['1830', 'Isolated neutron star'],
	['1840', 'Anomalous X-ray pulsar (AXP)'],
	['1850', 'Extrasolar planet'],
	['1860', 'Brown dwarf'],
	['1870', 'Protostar of Type 0'],
	['1880', 'Protostar of Type I'],
	['1890', 'Luminous Blue Variable (LBV)'],
	['1900', 'RS CVn star'],
	['1910', 'Algol star'],
	['1920', 'Beta Lyr star'],
	['1930', 'W UMa star'],
	['1940', 'Symbiotic star'],
	['1950', 'Zeta Aurigae star'],
	['1960', 'FK Comae star'],
	['1970', 'UV Ceti type'],
	['198.', 'T Tauri star'],
	['1990', 'Herbig Ae/Be star'],
	['1991', 'Be star'],
	['20..', 'Wolf Rayet'],
		['200.', ' unknown type'],
		['201.', ' WN'],
		['202.', ' WC'],
		['203.', ' WO'],
			['20.0', ' spectral type unknown'],
			['20.1', ' spectral type 1'],
			['20.2', ' spectral type 2'],
			['20.3', ' spectral type 3'],
			['20.4', ' spectral type 4'],
			['20.5', ' spectral type 5'],
			['20.6', ' spectral type 6'],
			['20.7', ' spectral type 7'],
			['20.8', ' spectral type 8'],
			['20.9', ' spectral type 9-11'],

	['21..', 'O'],
	['22..', 'B'],
	['23..', 'A'],
	['24..', 'F'],
	['25..', 'G'],
	['26..', 'K'],
	['27..', 'M'],
	['28..', 'Me'],
		['2[1-8]0.', ' spectral type 0'],
		['2[1-8]1.', ' spectral type 1'],
		['2[1-8]2.', ' spectral type 2'],
		['2[1-8]3.', ' spectral type 3'],
		['2[1-8]4.', ' spectral type 4'],
		['2[1-8]5.', ' spectral type 5'],
		['2[1-8]6.', ' spectral type 6'],
		['2[1-8]7.', ' spectral type 7'],
		['2[1-8]8.', ' spectral type 8'],
		['2[1-8]9.', ' spectral type 9'],
			['2[1-8].0', ' luminosity class unknown'],
			['2[1-8].1', ' luminosity class I or 0'],
			['2[1-8].2', ' luminosity class II'],
			['2[1-8].3', ' luminosity class III'],
			['2[1-8].4', ' luminosity class IV'],
			['2[1-8].5', ' luminosity class V'],
			['2[1-8].6', ' luminosity class VI'],

	['29..', 'Star'],
		['291.', ' Luyten color class a'],
		['292.', ' Luyten color class a-f'],
		['293.', ' Luyten color class f'],
		['294.', ' Luyten color class f-g'],
		['295.', ' Luyten color class g'],
		['296.', ' Luyten color class g-k'],
		['297.', ' Luyten color class k'],
		['298.', ' Luyten color class k-m'],
		['299.', ' Luyten color class m'],

	['30..', 'Extended galactic or extragalactic'],
	['31..', 'SNR Crab-like'],
	['32..', 'SNR'],
	['33..', 'Star forming region'],
	['34..', 'Cloud'],
	['35..', 'Nebula'],
	['36..', 'Open star cluster'],
	['37..', 'OB association/HII region'],
	['38..', 'Herbig-Haro object'],
	['39..', 'Diffuse X-ray emission'],
		['3.1.', ' Shell'],
		['3.2.', ' Filled-Center'],
		['3.3.', ' Composite'],
		['3.4.', ' Dark'],
		['3.5.', ' Molecular'],
		['3.6.', ' Planetary'],
		['3.7.', ' Reflection'],
		['3.8.', ' Globular Cluster'],
			['3..1', ' Radio Pulsar'],
			['3..2', ' Type I'],
			['3..3', ' Type II'],


	['4...', 'White dwarf'],
		['41..', ' DA'],
		['42..', ' DB'],
		['43..', ' DC'],
		['44..', ' DO'],
		['45..', ' DZ'],
		['46..', ' DQ'],
		['47..', ' DX'],
		['48..', ' sD'],
		['49..', ' PG1159-type'],
			['4.1.', ' A'],
			['4.2.', ' B'],
			['4.3.', ' C'],
			['4.4.', ' O'],
			['4.5.', ' Z'],
			['4.6.', ' Q'],
			['4.7.', ' X'],
			['4.8.', ' V'],
			['4.9.', ' P'],
				['4..1', ' PNN'],
				['4..2', ' PNN detached binary'],
				['4..3', ' detached binary'],
				['4..4', ' O'],
				['4..5', ' Z'],
				['4..6', ' Q'],
				['4..7', ' X'],
				['4..8', ' P'],
				['4..9', ' H'],

	['50..', 'Cluster of galaxies'],
		['501.', ' Abell class <0'],
		['502.', ' Abell class 0'],
		['503.', ' Abell class 1'],
		['504.', ' Abell class 2'],
		['505.', ' Abell class >2'],
		['506.', ' non-Abell'],
			['50.1', ' Cooling Flow'],

	['5100', 'Compact group of galaxies'],
	['5500', 'X-ray background'],
	['60..', 'Non-active galaxy'],

	['61..', 'Dwarf Galaxy'],
	['62..', 'Spiral galaxy'],
	['63..', 'Elliptical galaxy'],
	['64..', 'Starburst galaxy'],
	['65..', 'Interacting galaxy'],
	['66..', 'Irregular galaxy'],
	['67..', 'Galaxy'],
	['68..', 'Lenticular galaxy'],
	['69..', 'Normal galaxy'],
		['6[1-9]1.', ' radio loud'],
		['6[1-9]2.', ' HII region'],
		['6[1-9]3.', ' Multiple nuclei'],
		['6[1-9]4.', ' Barred'],
		['6[1-9]5.', ' Unbarred'],
		['6[1-9]6.', ' Mixed'],
		['6[1-9]7.', ' Nebulous region'],
			['6[1-9].1', ' flat radio spectrum'],
			['6[1-9].2', ' steep radio spectrum'],
			['6[1-9].3', ' inverted radio spectrum'],

	['70..', 'AGN Unclassified'],

	['71..', 'Seyfert'],
	['72..', 'QSO'],
	['73..', 'BL Lac'],
	['74..', 'Liner'],
	['75..', 'Radio Galaxy'],
	['76..', 'IR Galaxy'],
	['77..', 'OVV'],
		['7[1-7]1.', ' radio loud'],
		['7[1-7]2.', ' radio loud/polarized'],
		['7[1-7]3.', ' radio quiet'],
		['7[1-7]4.', ' radio loud/invert sp'],
		['7[1-7]5.', ' radio loud/flat sp'],
		['7[1-7]6.', ' radio loud/steep sp'],
		['7[1-7]7.', ' radio pol/invert sp'],
		['7[1-7]8.', ' radio pol/flat sp'],
		['7[1-7]9.', ' radio pol/steep sp'],
			['7[1-7].1', ' flat radio spectrum'],
			['7[1-7].2', ' steep radio spectrum'],
			['7[1-7].3', ' inverted radio spect'],
			['7[1-7].4', ' type 1'],
			['7[1-7].5', ' type 1.5'],
			['7[1-7].6', ' type 2'],

	['78..', 'NEL (Narrow Emission-Line) galaxy'],
	['79..', 'NLS1 (Narrow-Line Seyfert 1) galaxy'],
	['8000', 'Solar system object'],
	['81..', 'Planet'],
		['811.', ' Mercury'],
		['812.', ' Venus'],
		['813.', ' Earth'],
		['814.', ' Mars'],
		['815.', ' Jupiter'],
		['816.', ' Saturn'],
		['817.', ' Uranus'],
		['818.', ' Neptune'],
		['819.', ' Pluto'],

	['82..', 'Solar Feature'],
		['821.', ' Quiet Sun'],
		['822.', ' Active Sun'],
		['823.', ' Sunspot'],
		['824.', ' Plage/Active Region'],
		['825.', ' North Pole'],
		['826.', ' South Pole'],
		['827.', ' Equatorial Region'],
		['828.', ' Mid-Latitude Region'],
		['829.', ' Flare'],

	['83..', 'Asteroid'],
		['831.', ' Main Belt Object'],
		['832.', ' Centaur'],
		['833.', ' Kuiper Belt Object'],
		['834.', ' Near-Earth'],

	['84..', 'Comet'],
		['841.', ' Periodic'],
		['842.', ' Non-Periodic'],
		['843.', ' Sun-Grazingd'],

	['8500', 'Moon'],
	['9000', 'Unusual object'],
	['91..', 'Supernova'],
		['911.', ' Type I'],
		['912.', ' Type II'],

	['9200', 'Hypernova'],
	['9999', 'Unidentified']
);


sub new {
	my $self = shift;
	my $class = ();
	my $line = shift;
	if ( $line ) {
		my @fields = split /,/;
		foreach ( @fields ) { s/^\s+//; s/\s+$//;  }
		#    0      1       2         3           4        5
		#       NAME, RA_OBJ, DEC_OBJ, SOURCE_ID, ISGRI_FLAG, CLASS
		$class->{name} = $fields[0];
		$class->{ident} = URI::Escape::uri_escape ( $fields[0] );
		$class->{long} = _raobj2long ( $fields[1] );
		$class->{ra} = _dec2hms ( $fields[1] );
		$class->{ra_obj}  = sprintf ( "%f", $fields[1] );
		$class->{lat}  = sprintf ( "%f", $fields[2] ); #_decobj2long ( $fields[2] );
		$class->{dec} = _dec2dms ( $fields[2] );
		$class->{dec_obj} = sprintf ( "%f", $fields[2] );
		$class->{id} = $fields[3];
		$class->{id_esc} = URI::Escape::uri_escape ( $fields[3] );
		$class->{isgri_flag} = $fields[4];
		$class->{class} = sprintf ( "%d", $fields[5] );
		( $class->{type}, $class->{style} ) = _class2type ( sprintf ( "%d", $fields[5] ), 2 );
		$class->{marker} = ( $class->{style} ) ? "../diamonds/$class->{style}.png" : "";
	}
	bless $class;
	return $class;
}

sub display {
	my $self = shift;
	print "Name   :$self->{name}:\n";
	print "Ident  :$self->{ident}:\n";
	print "Long   :$self->{long}:\n";
	print "Ra     :$self->{ra}:\n";
	print "Ra_Obj :$self->{ra_obj}:\n";
	print "Lat    :$self->{lat}:\n";
	print "Dec    :$self->{dec}:\n";
	print "Dec_Obj:$self->{dec_obj}:\n";
	print "ID     :$self->{id}:\n";
	print "Class  :$self->{class}:\n";
	print "Type   :$self->{type}:\n";
	print "Marker  :$self->{marker}:\n";
	print "Style  :$self->{style}:\n";
	print "ISGRI_FLAG  :$self->{isgri_flag}:\n";
}

sub _raobj2long {
	return sprintf ( "%f", $_[0] - 180 );
}

sub _decobj2long {
	return sprintf ( "%f", $_[0] );
}

#	Decimal to Degrees/Minutes/Seconds
sub _dec2dms {
	my $in = shift;
	my $d = $in;
	my $sign = $d <= 0 ? '-' : '+';
	$d = abs ($d);
	my $h = POSIX::floor ($d);
	$d = POSIX::fmod ($d, 1) * 60.0;
	my $s = POSIX::fmod ($d, 1) * 60.0;
	my $ss = sprintf ("%02.0f", $s);
	if ($ss eq '60') {
		$ss = '00';
		$d += 1;
		if ($d == 60) {
			$h += 1;
		}   
	}
	return sprintf ("$sign%02d&deg;&nbsp;%02.0f&apos;&nbsp;%s&quot;", $h, POSIX::floor($d), $ss );
}

#	Decimal to Hours/Minutes/Seconds
sub _dec2hms {
	my $in = shift;
	my $d = $in;
	my $a = $d;
	$d = $d / 15.0;
	my $h = POSIX::floor ($d);
	$d = POSIX::fmod ($d, 1) * 60.0;
	my $s = POSIX::fmod ($d, 1) * 60.0; 
	my $ss = sprintf ("%04.1f", $s);
	if ($ss eq '60.0') {
		$ss = '00.0';
		$d += 1;
		if ($d == 60) {
			$h += 1;
			if ($h == 24) {
				$h = 0;
				$d = 0;
			}
		}
	}
	return sprintf ("%02dh&nbsp;%02.0fm&nbsp;%ss", $h, POSIX::floor($d), $ss );
}


sub _class2type {
	my $val = shift;
	my $depth = shift || 1;
	my $i = 1;
	my $type;
	my $color;
	foreach my $class (@isdc_classes) {
		my $id = @{$class}[0];
		if ($val =~ /$id/) {
			$type .= @{$class}[1];
			$color = sprintf ( "%03d", int(($i/$#isdc_classes)*360) );
			last if ( --$depth <= 0 );
		}
		$i++;
	}
	$type  = "Unknown $val" unless $type;
	$color = "black" unless $color;
	return $type, $color;
}






return 1;

__END__

From: 

http://heasarc.gsfc.nasa.gov/W3Browse/catalog/class.html
http://isdc.unige.ch/Data/cat/class.html 

Object Classes

1000 - X-ray binary
1100 - HMXRB                  10 - X-ray pulsar      1 - flares
1200 - HMXRB supergiant       20 - burster           2 - jets
1300 - HMXRB Be star          30 - black hole        3 - eclipsing
1400 - LMXRB                  40 - QPO               4 - ultra-soft transient
1500 - LMXRB Globular cluster 50 - QPO & black hole  5 - soft transient
                              60 - QPO & pulsar      6 - hard transient
                              70 - QPO & bursts      7 - eclipsing dipper
                              80 - QPO,pulsar,bursts 8 - eclipsing ADC
                              90 - pulsar & bursts   9 - dipper

1600 - CV                 10 - Classical Nova         1 - oscillations
                          20 - Recurrent Nova         2 - coherent osc.
                          30 - AM Her (polar)         3 - fast
                          40 - Intermediate polar     4 - slow
                          50 - Dwarf nova             5 - eclipsing
                          60 - Dwarf nova U Gem type  6 -
                          70 - Dwarf Nova Z Cam type  7 -
                          80 - Dwarf Nova SU Uma type 8 -
                          90 - Nova like              9 -

1700 - Gamma ray          00 - source                 1 - pulsar
                          10 - burst
                          20 - burst, soft repeater

1800 - Radio Pulsar
1810 - X-ray pulsator
1820 - Supersoft source
1830 - Isolated neutron star
1840 - Anomalous X-ray pulsar (AXP)
1850 - Extrasolar planet
1860 - Brown dwarf
1870 - Protostar of Type 0
1880 - Protostar of Type I
1890 - Luminous Blue Variable (LBV)

1900 - RS CVn star
1910 - Algol star
1920 - Beta Lyr star
1930 - W UMa star
1940 - Symbiotic star
1950 - Zeta Aurigae star
1960 - FK Comae star
1970 - UV Ceti type
1980 - T Tauri star       1 - (naked)
                          2 - (post)
1990 - Herbig Ae/Be star
1991 - Be star

2000 - Wolf Rayet    00 - unknown type     00 - spectral type unknown
                     10 - WN               10................ 1
                     20 - WC               20................ 2
                     30 - WO               30................ 3
                                           40................ 4
                                           50................ 5
                                           60................ 6
                                           70................ 7
                                           80................ 8
                                           90................ 9-11

                 00 - spectral type 0    0 .... luminosity class unknown
2100 - O         10................ 1    1 ..................... I or 0
2200 - B         20................ 2    2 ..................... II
2300 - A         30................ 3    3 ..................... III
2400 - F         40................ 4    4 ..................... IV
2500 - G         50................ 5    5 ..................... V
2600 - K         60................ 6    6 ..................... VI
2700 - M         70................ 7
2800 - Me        80................ 8
                 90................ 9

2900 - Star

                 10 - Luyten color class a
                 20 - Luyten color class a-f
                 30 - Luyten color class f
                 40 - Luyten color class f-g
                 50 - Luyten color class g
                 60 - Luyten color class g-k
                 70 - Luyten color class k
                 80 - Luyten color class k-m
                 90 - Luyten color class m


3000 - Extended galactic or extragalactic
3100 - SNR Crab-like               10 - Shell            1 - Radio Pulsar
3200 - SNR                         20 - Filled-center    2 - Type I
3300 - Star forming region         30 - Composite        3 - Type II
3400 - Cloud                       40 - Dark
3500 - Nebula                      50 - Molecular
3600 - Open star cluster           60 - Planetary
3700 - OB association/HII region   70 - Reflection
3800 - Herbig-Haro object          80 - Globular Cluster
3900 - Diffuse X-ray emission

4000 - White dwarf                00 -         0 -
4100 - White dwarf DA             10 - A       1 - PNN
4200 - White dwarf DB             20 - B       2 - PNN detached binary
4300 - White dwarf DC             30 - C       3 - detached binary
4400 - White dwarf DO             40 - O       4 - O
4500 - White dwarf DZ             50 - Z       5 - Z
4600 - White dwarf DQ             60 - Q       6 - Q
4700 - White dwarf DX             70 - X       7 - X
4800 - White dwarf sD             80 - V       8 - P
4900 - White dwarf PG1159-type    90 - P       9 - H


5000 - Cluster of galaxies        10 - Abell class <0     1 - Cooling Flow
                                  20 - Abell class 0
                                  30 - Abell class 1
                                  40 - Abell class 2
                                  50 - Abell class >2
                                  60 - non-Abell
5100 - Compact group of galaxies

5500 - X-ray background

6000 - Non-active galaxy
6100 - Dwarf Galaxy        10 - radio loud        1 - flat radio spectrum
6200 - Spiral galaxy       20 - HII region        2 - steep radio spectrum
6300 - Elliptical galaxy   30 - Multiple nuclei   3 - inverted radio spectrum
6400 - Starburst galaxy    40 - Barred
6500 - Interacting galaxy  50 - Unbarred
6600 - Irregular galaxy    60 - Mixed
6700 - Galaxy              70 - Nebulous region
6800 - Lenticular galaxy
6900 - Normal galaxy

7000 - AGN Unclassified
7100 - Seyfert         10 - radio loud           1 - flat radio spectrum
7200 - QSO             20 - radio loud/polarized 2 - steep radio spectrum
7300 - BL Lac          30 - radio quiet          3 - inverted radio spect
7400 - Liner           40 - radio loud/invert sp 4 - type 1
7500 - Radio Galaxy    50 - radio loud/flat sp   5 - type 1.5
7600 - IR Galaxy       60 - radio loud/steep sp  6 - type 2
7700 - OVV             70 - radio pol/invert sp
                       80 - radio pol/flat sp
                       90 - radio pol/steep sp
7800 - NEL (Narrow Emission-Line) galaxy
7900 - NLS1 (Narrow-Line Seyfert 1) galaxy

8000 - Solar system object
8100 - Planet          10 - Mercury
                       20 - Venus
                       30 - Earth
                       40 - Mars
                       50 - Jupiter
                       60 - Saturn
                       70 - Uranus
                       80 - Neptune
                       90 - Pluto
8200 - Solar Feature   10 - Quiet Sun
                       20 - Active Sun
                       30 - Sunspot
                       40 - Plage/Active Region
                       50 - North Pole
                       60 - South Pole
                       70 - Equatorial Region
                       80 - Mid-Latitude Region
                       90 - Flare
8300 - Asteroid        10 - Main Belt Object
                       20 - Centaur
                       30 - Kuiper Belt Object
                       40 - Near-Earth
8400 - Comet           10 - Periodic
                       20 - Non-Periodic
                       30 - Sun-Grazing
8500 - Moon

9000 - Unusual object
9100 - Supernova       10 - Type I
                       20 - Type II
9200 - Hypernova

9999 - unidentified

