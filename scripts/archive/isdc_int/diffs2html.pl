#! /bin/sh
eval '  exec perl -x $0 ${1+"$@"} '
#!/usr/bin/perl -s

use File::Basename;
#use strict;

$FUNCNAME    = basename($0);
$FUNCVERSION = 0.04;

$STR_EMPTY = "---";

$DS{DIFFERENT}{str} = "different";
$DS{UNIQUE}   {str} = "unique   ";
$DS{SAME}     {str} = "same     ";

$DS{DIFFERENT}{order} = 2;
$DS{UNIQUE}   {order} = 1;
$DS{SAME}     {order} = 0;



if ( @ARGV <= 1) {
	print "\n" 
		."$FUNCNAME ERROR: Expecting at least two arguments for VERSION files to \n"
		." compare.  Aborting... \n\n";
	exit 2;
}

my @filelist = @ARGV;
my %comp;

foreach my $file ( @filelist ) {
	if ( ! -f $file ) {
		print "\n";
		print "ERROR: file not found: + $file +\n";
		print "  Aborting...\n";
		print "\n";
		exit 2;
	}
	&readFile ( $file );
}

&writeTable ( $html );

exit 0;


#------------------------------------------------------------------------------
# Function
#------------------------------------------------------------------------------
sub readFile {
	
	local $file    = $_[0];
	
	open(FILE,"<$file") or 
	&die("Could not open file + $file +",(caller(0))[3]);		#	what does ,(caller(0))[3]) mean?
	
	while (<FILE>){
		$line = $_;
		chomp $line;
		
		last if ($line eq "__END__\n");      # Anything past __END__ is ignored.
		next if (index($line,"#") == 0);     # ignore comments
		next if (m/^\s*\n$/);                # skip {0,n} whitespace lines
		my @words;
		if ( $line =~ / = / ) {	
			@words = split(' = ',$line);
		} 
		else {
			@words = split /\s+/, $line;
		}
		$compName = $words[0];
		$comp{$compName}{$file} = $words[1];
#		$comp{$compName}{$file} = ( defined $words[1] ) ? $words[1] : "UNDEF";
	}

	close FILE;
}

#------------------------------------------------------------------------------
# Function
#------------------------------------------------------------------------------
sub writeTable {
	my ( $html ) = @_;
	
	# Determine the diffState  
VARIABLE:	foreach $variable (keys %comp) {

		#	Testing...  This is to set something to compare when comparing component lists
		for ( my $i=0; $i<@filelist; $i++ ) {
			$comp{$variable}{$filelist[$i]} = "N/A" unless ( exists $comp{$variable}{$filelist[$i]} );
		}

		$comp{$variable}{diffState} = "UNIQUE";	#	default is unique
		for ( my $i=1; $i<@filelist; $i++ ) {		#	skip the first one as it is used as the base to compare
			if ( $comp{$variable}{$filelist[0]} eq $comp{$variable}{$filelist[$i]} ) {
				$comp{$variable}{diffState} = "SAME";		#	only needed the first time, but whatever
			} else {
				$comp{$variable}{diffState} = "DIFFERENT";
				next VARIABLE;
			}
		}
	}


	print "<html><head><style>td { text-align: center; }</style></head><body><center><table width=100% wordwrap=1 border=\"1\">\n" if ( $html );
	# Print result in particular order (by category, then alphabetical 
	# within category).
	foreach $variable (sort { 
			$a->[0] <=> $b->[0]   # note reverse sort!
			||
			$a->[1] cmp $b->[1]
		} map { [
			$DS{$comp{$_}{diffState}}{order}, 
			$_,
		] } keys %comp) {
	
#		$variable = $variable->[1];	#	don't really know what this is for
		my $bgcolor = "white";
		$bgcolor = "yellow" if ( $DS{$comp{$variable}{diffState}}{str} eq $DS{DIFFERENT}{str} );
		$bgcolor = "red"    if ( $DS{$comp{$variable}{diffState}}{str} eq $DS{UNIQUE}{str} );

		print "<tr bgcolor=$bgcolor>\n\t<td>$DS{$comp{$variable}{diffState}}{str}</td>\n\t<td>$variable</td>\n" if ( $html );
		printf ("%-12s  %-25s"
			, $DS{$comp{$variable}{diffState}}{str}
			, $variable 
			) unless ( $html );   # closing semi-colon
		foreach my $file ( @filelist ) {
			printf ("  %-12s", $comp{$variable}{$file} ) unless ( $html );
			my @temp; 			#	using this to make the text word wrap as some of these variable are long and without spaces
			while ( length $comp{$variable}{$file} ) {
				push @temp, substr $comp{$variable}{$file}, 0, 25, "";
			}
			print "\t<td>@temp</td>\n" if ( $html );
#			print "\t<td>$comp{$variable}{$file}</td>\n" if ( $html );
		}
		print "</tr>\n" if ( $html );
		print "\n";
	}
	if ( $html ) {
		print "<tr>\n\t<td>Status</td>\n\t<td>Parameter</td>\n";
		foreach my $file ( @filelist ) {
			print "\t<td>$file</td>\n";
		}
		print "</tr>\n";
		print "</table></center></body></html>\n";
	}
}

__END__


#last line
