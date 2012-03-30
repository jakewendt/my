#! /bin/sh
eval '  exec /opt/csw/bin/perl -x $0 "$@" '
#if [ `uname -n` = "isdcul3" ]
#then
#	eval '  exec /isdc/sw/perl/5.6.1/WS/7/bin/perl -x $0 "$@" '     #       ISDC
#else
#	eval '  exec /usr/bin/perl -x $0 "$@" ' #       NOT ISDC
#fi
#! perl -w

use strict;
use source;
use FileHandle;
use XML::Simple;

`mkdir out` unless ( -d 'out' );

while(<>) {
	next if /^\s*$/;
	my $source = new Source($_);

	if ( $source->{isgri_flag} ) {
		my %hash = ( 'heuSrc' => {
				'Name'       => $source->{name},
				'ID'         => $source->{id},
				'Ra'         => $source->{ra_obj},
				'Dec'        => $source->{dec_obj},
				'Class'      => $source->{class},
				'Type'       => $source->{type},
				'Image'      => "Insert Image",
				'Description'=> "Insert Description",
			}
		);
#		print XMLout(\%hash, XMLDecl => 1, NoAttr => 1, KeepRoot => 1);
		$source->{name} =~ s/\ /_/g;
		`mkdir out/$source->{name}` unless ( -d "out/$source->{name}" );
		open INFO, "> out/$source->{name}/info.xml";
		print INFO XML::Simple::XMLout(\%hash, XMLDecl => 1, NoAttr => 1, KeepRoot => 1); 
		close INFO;
	}

}
