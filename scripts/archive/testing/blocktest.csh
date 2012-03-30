#!/usr/bin/csh -f



foreach num ( 1 2 3 4 5 6 7 8 9 )
	echo $num

	if ( $num < 1 ) then		#	it would appear that the open portion of an if/then/else statement 
									#	will execute properly with the missing endif.  The closed will not.
		echo "< 1"
	else
		echo ">= 1"

	foreach num2 ( 1 2 3 4 5 6 7 8 9 )
		echo $num $num2
	end
end


