#!/usr/bin/perl -w

sub RunProgram;


RunProgram ( "this is my command and not a parameter", "par1", "par2" );
#RunProgram ( "this is my second command with no parameters" );

Other ();
Other ("A");
Other (1);
Other ("B", "C");

exit;

sub Other {
	my $par = $_[0] if defined($_[0]);
	print "Other - $par\n";
}


sub RunProgram {

	my @pars = @_;
	my $n;

	my $x = "";

	print "\$\#pars - $#pars\n";

	if ( $#pars > 0 ) {
		for ( $n=1; $n <= $#pars; $n++ ) {
			print "$pars[$n]\n";
		}
	}

	print "testing\n" unless ( ( $pars[2] =~ /par/ ) and ! ( $x ) );

	foreach my $num ( 1,2,3){
		print $num;
	}
}


