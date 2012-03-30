
package ISDCStep;

#use strict;

sub new {
	my $classname = shift; # What class are we constructing?
	my $self = {}; # Allocate new memory
	bless($self, $classname); # Mark it of the right type
	( $self->{StepName}, $self->{StepFunc}) = @_;
	return $self; # And give it back
}

sub StepName {
	my $self = shift;
	if (@_) { $self->{StepName} = shift }
	return $self->{StepName};
}

sub runme {
	my $self = shift;
	if ( exists($self->{StepFunc}) ) {
		if ( defined($self->{StepFunc}) ) {
			print "Running $self->{StepFunc}\n";
			&{$self->{StepFunc}}($self->{StepName},1);											#	You cannot do this if you have set "use strict;"!
		}
		else { print "Undefined \$self->{StepFunc}\n"; } }
	else { print "Non-existant \$self->{StepFunc}\n"; }
}




sub testfunc {	#	internal function
	print "In testfunc - @_\n";
}


return 1;

