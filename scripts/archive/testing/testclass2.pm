
package testclass2;

$Body_Count = 0;
$myname = "";

sub population { return $Body_Count }
sub myname { return $myname }

sub new { 
	($packagename, $myname) = @_;
	$Body_Count++; 
	return bless({}, shift);
}

sub DESTROY { --$Body_Count }


return 1;

