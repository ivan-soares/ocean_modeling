#!/bin/bash
#
	today=$1

	#ls -1 d-inputs/hncoda_bsa0.08_06h/glby_${today}* >& list_of_files
	ls -1 d-storage/glby_bsa0.10/roms_clm_${today}* >& list_of_files

	cdo="cdo -s --no_warning"

	while read line; do
		#echo " ... reading file $line"
		$cdo showtimestamp $line
	done < list_of_files

#
#   the end
#


