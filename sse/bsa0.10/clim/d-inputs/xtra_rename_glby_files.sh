#!/bin/bash
#
	ddir="hncoda_glby_npo0.08_167W117W-15N47N_06h"

	cd $ddir
	pwd
	ls -1 glby_2020* >& list

	while read line; do

		ddate=`echo $line | sed -e "s/\_/ /g" -e "s/\./ /g"  | awk '{print $2}'`

		echo "glby_npo_${ddate}.nc"

		mv $line "glby_npo_${ddate}.nc"

	done < list

#

