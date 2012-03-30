#! /bin/sh
eval '  exec /opt/csw/bin/perl -x $0 "$@" '
#eval '  exec /isdc/sw/perl/5.6.1/WS/7/bin/perl -x $0 "$@" '
#eval '  exec /usr/bin/perl -x $0 "$@" '
#! perl -w

use strict;
use FileHandle;
use XML::Simple;

my $ref = XML::Simple::XMLin( $ARGV[0], SuppressEmpty => 1 );

print "${$ref}{$ARGV[1]}\n" if exists ${$ref}{$ARGV[1]};

#foreach ( keys ( %{$ref} ) ) {
#	print "$_ = ${$ref}{$_}\n";
#}

exit;

__END__

