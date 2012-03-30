#!/usr/bin/perl -w

sub RunProgram;

#	defining a prototype here seems to be purely aesthetic for the user
#		and serves no use for perl

#	using an ampersand seems to be purely aesthetic for the user
#		and serves no use for perl

RunProgram ( "this is my command and not a parameter", "par1", "par2" );
Other ();
Other ("A");
Other (1);
Other ("B", "C");

&RunProgram ( "this is my command and not a parameter", "par1", "par2" );
&Other ();
&Other ("A");
&Other (1);
&Other ("B", "C");

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


