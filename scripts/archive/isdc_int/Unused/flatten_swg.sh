#!/bin/sh


# ll 0*/0*/swg*.fits

cwd=`pwd`

for each in `/bin/ls -d 0*/0*`
do
	echo $each
	cd $each

#
#ibis_diagnostic                                               <
#ibis_diagnostic                                               <
#                                                              > ibis_prp_diag
#                                                              > ibis_raw_diag
#jmx1_diag                                                     <
#jmx1_diag                                                     <
#                                                              > jmx1_prp_diag
#                                                              > jmx1_raw_diag
#jmx2_diag                                                     <
#jmx2_diag                                                     <
#                                                              > jmx2_prp_diag
#                                                              > jmx2_raw_diag
#

	mv ./eng/raw/ibis_diagnostic.fits.gz ./ibis_raw_diag.fits.gz
	mv ./eng/prp/ibis_diagnostic.fits.gz ./ibis_prp_diag.fits.gz
	mv ./eng/raw/jmx1_diag.fits.gz ./jmx1_raw_diag.fits.gz
	mv ./eng/prp/jmx1_diag.fits.gz ./jmx1_prp_diag.fits.gz
	mv ./eng/raw/jmx2_diag.fits.gz ./jmx2_raw_diag.fits.gz
	mv ./eng/prp/jmx2_diag.fits.gz ./jmx2_prp_diag.fits.gz

	for eachfile in `/bin/ls [eijos]*/*/*`
#	mv [eijos]*/*/* . 
	do
		mv $eachfile .
	done
	rmdir [eijos]*/* 
	rmdir [eijos]* 2> /dev/null

	chmod +w swg*.fits
	flatten_swg.pl swg*.fits 
	cd $cwd
done

