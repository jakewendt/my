
#!/bin/sh
mkdir Corrected

for each in `/bin/ls DCP*`
do
	for date in 16 17 18 19 20 21 22 23
	do	
		for hour in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23
		do
			newhour=`expr $hour + 6`
			newhour=`printf '%02d' $newhour`
#			echo "$each:$date:$hour:$newhour"
			if ( `grep "2003:08:$date\ $hour" $each > /dev/null` )
			then
				echo "Found $date:$hour in $each"
				sed s/2003:08:$date\ $hour/2003:08:$date\ $newhour/g $each > Corrected/$each
			fi
		done
	done
done
