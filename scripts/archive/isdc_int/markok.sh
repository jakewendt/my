#!/bin/sh -x

chmod +w $1
chmod +w $1/dircmp.analysis
chmod +w $1/flag.html

cat >> $1/dircmp.analysis << EOF

As there has been no opposition to the reprocessed results,
I am marking these differences as acceptable so I don't have to keep looking at them.

Jake - 040823

	EOF

cp /home/isdc_guest/isdc_int/WWW/check_flag.html $1/flag.html

chmod -w $1/dircmp.analysis
chmod -w $1/flag.html
chmod -w $1

