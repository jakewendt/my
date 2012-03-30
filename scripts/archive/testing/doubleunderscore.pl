#! /bin/sh
eval '  exec perl -x $0 ${1+"$@"} '
#! perl -w

my %FILES;
my $name = "DATA";

while (<DATA>) {
	if ( /^__(.+)__/ ) {
		$name = $1;
		next;
	}
	push @{$FILES{$name}}, $_;
}

foreach my $key ( keys (%FILES) ) {
	print "-$key-\n";
	foreach my $line ( @{$FILES{$key}} ) {
		print $line;
	}
}

__END__
1
__DATA__
2
This is the content of the DATA file.
3
__MORE__

This is the initial content of the MORE file.

__END__

This is the content of the END file.

__MORE__

This is the appended content of the MORE file.

Please note that for all of these using the same name multiple times will append.

Also note that the DATA file will begin with the END tag or the DATA tag.  Whichever comes first.
HOWEVER, if you use the END tag inside the DATA tag as I have done here, you will get a END file.
I can't really control this.



