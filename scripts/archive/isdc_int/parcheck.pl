#!/usr/bin/perl -w

use strict;

my $status = 0;
my $execname;
my %parameters = ();
my $filename = "";
my $FUNCNAME = "parcheck";
my $FUNCVERSION = "1.5";
my $compare_values_too = "";

# exit unless ( $#ARGV >= 0 );

while ($_ = $ARGV[0], /^-.*/) {
	if ($_ eq "-h"		||
		$_ eq "--h"		||
		$_ eq "--help") {
		print 
		"\n\n"
		."Usage:  $FUNCNAME  [options] file(s)\n"
		."\n"
		."  -v, --v, --version -> version number\n"
		."  -h, --h, --help    -> this help message\n"
		."  --value, --values  -> compares values also\n"
		."     by default, parcheck only compares parameter names\n"
		."\n\n"
		; # closing semi-colon
		exit 0;
	}

	elsif ($_ eq "-v"		||
		$_ eq "--v"			||
		$_ eq "--version") {
		print "Log_1  : Version : $FUNCNAME $FUNCVERSION\n";
		exit 0;
	}

	elsif ($_ eq "--value"		||
		$_ eq "--val"				||
		$_ eq "--vals"				||
		$_ eq "--values") {
		$compare_values_too = "y";
	}

	else {  # all other cases
		print "ERROR: unrecognized option +$ARGV[0]+.  Aborting...\n";
		print "\n";
		exit 1;
	}
	shift @ARGV;
}     # while options left on the command line


while ( $ARGV[0] ) {
	$filename = $ARGV[0];
	open CURFILE, $filename;
	while (<CURFILE>) {
		next if ( /^\s*#/ );		#	skip comments
		next if ( /^\s*$/ );		#	skip blank linea
		#	next if ( /\"program_name\" => "\$my/ );	#	"program_name" => "$my
		if ( /\"program_name\"/ ) {
			$execname = $_;
			$status = ExecName ( $status );
			$status = FindParsInCode( $status );
			$status = FindParsInParFile( $status );
			$status = CompPars( $status );
		}
		$status = 0;
		%parameters = ();
	}
	close CURFILE;
	shift @ARGV;
}     # while options left on the command line

exit;


#########################################################


sub FindParsInCode {
	my $status = shift;
	return $status if ( $status != 0 );

	while (<CURFILE>) {
		next if ( /^#/ );
		next if ( /^\s*$/ );
		last if ( /\)\;/ );

		# Ex.
		#                 "par_Subsystem" => "ADP",		# may be a comment
		#                  "par_ScWIndex" => $scw_prp_index,		# some comment
		#                    "par_idxSwg" => "scw/${revno}/${scwid}.000/swg_prp.fits[GROUPING]",
		#        "par_IBIS_IP_E_band_max" => "200 250 300 350 400 2000 4700 7200",
		#             "par_AttributeData" => "raw/$dataset"."[${struct}]",

		chomp;                     #       remove carriage return
		s/^(.*)\#.*$/$1/;          #       remove everything after #
		s/^\s+//;                  #       remove leading white space (I must be a racist!)
		s/\s+$//;                  #       remove trailing white space (I must be a racist!)

		if ( /^\s*\"par_([\w\d\-\+\.]+)\"\s*=>/ ) {
			my $parameter = $1;
			if ( /=>\s*(\"{0,1}["\$<>#\-+\,\.\? \w\d\/\(\)\{\}\[\]]*\"{0,1})\,$/ ) {
				$parameters { $parameter }{"code"} = $1;
			} else {
				$parameters { $parameter }{"code"} = "";
			}
			$parameters { $parameter }{"code"} =~ s/^\"(.*)\"$/$1/;
#			print "CODE:  ".${parameter}." : -".$parameters { $parameter }{"code"}."-\n";
		}
	}

	return 0;
}


sub ExecName {
	my $status = shift;
	return $status if ( $status != 0 );

	$execname =~ s/^(\s*\"program_name\"\s*\=\>\s*\")//;
	$execname =~ s/^(.*)[^\$\\]{1}\#.*$/$1/;
	$execname =~ s/(\"\,\s*)$//;

#	print "Found exec : $execname\n";

	return 1  if ( $execname =~ /NONE/ );
	return 2  if ( $execname =~ /ERROR/ );
	return 3  if ( $execname =~ /ISDCPipeline/ );
#	return 4  if ( $execname =~ /touch/ );
	return 5  if ( $execname =~ /COPY/ );
	return 6  if ( $execname =~ /CHECK/ );
	return 7  if ( $execname =~ /osf_create/ );
	return 8  if ( $execname =~ /osf_update/ );
#	return 9  if ( $execname =~ /^tar / );
#	return 10 if ( $execname =~ /^mv / );
#	return 11 if ( $execname =~ /^cp / );
	return 12 if ( $execname =~ /^\$my/ );

	return 0;
}


sub FindParsInParFile {
	my $status = shift;
	return $status if ( $status != 0 );

	my $parfile = "$ENV{ISDC_ENV}/pfiles/".$execname.".par";

	open(PARS,"$parfile") or $status = 1;
	if ( $status == 1 ) {
		printf ( "ERROR : %-12s : %-20s :  ERROR. Cannot open parfile for this executable.\n", $filename, $execname );
		return $status;
	}

	while(<PARS>) {
		# real par lines, as oposed to comments which can be in various forms, must
		#  begin with a word character (could be stricter, but this should do)
		next unless (/^\s*\w/);
		my ($parameter,$type,$mode,$default,$min,$max,$comment) = ParParse($_);
		# remove any white spaces in parameter
		$parameter =~ s/\s+//g;

		if ( defined ($default) ) {
			#  and replace mutliple whitespace with single space in default value
			$default =~ s/\s+/ /g;
			# remove any quotes (Do these have to be escaped?)
			$default =~ s/\"|\'//g;
			#  Remove leading or trailing spaces.
			$default =~ s/^\s*(\S*)\s*$/$1/g;
	
			#  Replace $ with $ENV{}
			#  This is:    $ {? xxx  }?  $ENV{xxx}  
			$default =~ s/\$\{?(\w+)\}?/\$ENV\{$1\}/;

			$parameters { $parameter }{"parfile"} = $default;	# i may use this to compare actual values of parameters
		}
		else {
			$parameters { $parameter }{"parfile"} = "";
		}

#		$parameters { $parameter }{"parfile"} = "X";
	}
	close PARS;

	return 0;
}


sub CompPars {
	my $status = shift;
	my $code_pattern = "%s%-25s : %-21s : \"par_%s\" => \"%s\",   in code.\n";
	my $par_pattern =  "%s%-25s : %-21s : \"par_%s\" => \"%s\",   in par file\n";
	return $status if ( $status != 0 );

	foreach my $parameter ( sort {$a cmp $b} ( keys %parameters) ) {
		if ( !defined $parameters{$parameter}{"parfile"} ) {				#	only in code
			printf ( $code_pattern, "", $filename, $execname, $parameter, $parameters{$parameter}{"code"}    );
		}
		elsif ( !defined $parameters{$parameter}{"code"} ) {				#	only in par file
			printf (  $par_pattern, "", $filename, $execname, $parameter, $parameters{$parameter}{"parfile"} );
		}
		elsif ($parameters{$parameter}{"parfile"} ne $parameters{$parameter}{"code"}) {
			if ( $compare_values_too ) {
				printf ( "--> Code and par file values differ. \n");
				printf ( $code_pattern, "\t", $filename, $execname, $parameter, $parameters{$parameter}{"code"}    );
				printf (  $par_pattern, "\t", $filename, $execname, $parameter, $parameters{$parameter}{"parfile"} );
			}
		}
		elsif ($parameters{$parameter}{"parfile"} eq $parameters{$parameter}{"code"}) {
			#	Don't do anything;
			#	$parameters{$parameter}{diffState} = "SAME";
		}
	}

	return 0;
}


#  This is straight out of the Perl cookbook, pg 31, sect 1.15:
sub ParParse {
  my $text = shift;
  my @new = ();
  push(@new,$+) while $text =~ m{
                                 "([^\"\\]*(?:\\.[^\"\\]*)*)",?
                                 |  ([^,]+),?
                                 | ,
                                }gx;
  push(@new,undef) if substr($text, -1,1) eq ',';
  return @new;

}


