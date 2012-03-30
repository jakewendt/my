
package package2;

use package1;

use Exporter();
@ISA = qw ( Exporter );
@EXPORT = qw ( 
	&pkg2test 
	&pkg2print 
	);


sub pkg2test {
	print "In pkg2test\n";
	&pkg1print();
	print "Out pkg2test\n";
}

sub pkg2print {
	print "pkg2print\n";
}




1;


