#!/usr/bin/perl -w
use File::Basename;

my $dir = $ARGV[0];

print "Checking dir $dir\n";

my $pwd = `pwd`;
chomp $pwd;
print "$pwd/$dir\n";
print basename("$pwd/$dir")."\n";



#	my @filelist = glob ( "$dir/*" );
#	
#	if ( @filelist ) {
#		print "Dir $dir is not empty\n";
#	}
#	else {
#		print "Dir $dir is empty\n";
#	}
if ( -w $dir  ) {
	print "Dir $dir is writeable\n";
}
else {
	print "Dir $dir is NOT writeable\n";
}

if ( -w "$dir/.."  ) {
	print "Dir $dir/.. is writeable\n";
}
else {
	print "Dir $dir/.. is NOT writeable\n";
}

#	if ( -o $dir  ) {
#		print "Dir $dir is is owned by effective owner of this script\n";
#	}
#	else {
#		print "Dir $dir is NOT is owned by effective owner of this script\n";
#	}
#	
#	if ( -O $dir  ) {
#		print "Dir $dir is is owned by real owner of this script\n";
#	}
#	else {
#		print "Dir $dir is NOT is owned by real owner of this script\n";
#	}

exit;


