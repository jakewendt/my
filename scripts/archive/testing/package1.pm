
package package1;

use package2;
#use lib "/isdc/integration/isdc_int/sw/dev/prod/opus/pipeline_lib/";
#use ISDCLIB;

use Exporter();
@ISA = qw ( Exporter );
@EXPORT = qw ( $pkg1 %myhash &mytestroutine );

sub package1::mytestroutine;

$pkg1 = "test";

%myhash = ( "one", "ONE", "two", "TWO" );


sub mytestroutine {
	print "test in mytestroutine\n";
#	&Message(  "test2" );
	print "This is in my test routine.\n";
}


#1;

