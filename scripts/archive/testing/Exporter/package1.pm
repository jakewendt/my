
package package1;

use package2;

use Exporter();
@ISA = qw ( Exporter );
@EXPORT = qw ( 
	&pkg1test 
	&pkg1print 
	);


sub pkg1test {
	print "In pkg1test\n";
	&pkg2print();
	print "Out pkg1test\n";
}

sub pkg1print {
	print "pkg1print\n";
}


1;

