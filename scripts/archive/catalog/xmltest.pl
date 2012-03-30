#! /bin/sh
eval '  exec /opt/csw/bin/perl -x $0 "$@" '
#eval '  exec /isdc/sw/perl/5.8.6/WS/7/bin/perl -x $0 "$@" '
#eval '  exec /isdc/sw/perl/5.6.1/WS/7/bin/perl -x $0 "$@" '
#eval '  exec /usr/bin/perl -x $0 "$@" '
#! perl -w

use strict;
use FileHandle;
use XML::Simple;

foreach ( @INC ) {
#        print "$_\n";
}

foreach ( %INC ) {
        print "$_\n";
}

