
package package2;

use package1;

#use lib "/isdc/integration/isdc_int/sw/dev/prod/opus/pipeline_lib/";
#use ISDCLIB;

use Exporter();
@ISA = qw ( Exporter );
@EXPORT = qw ( &mytestroutine2 );

sub package2::mytestroutine2;

sub mytestroutine2 {
	print "In mytestroutine2\n";
	&mytestroutine();
#	&Message( "test" );
	print "Leaving mytestroutine2\n";
}




#1;


