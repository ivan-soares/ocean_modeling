#!/bin/bash
#
	today=$1

	ls -1 d-inputs/gfs/gfs_$today >& list_of_files

	cdo="cdo -s --no_warning"

	while read line; do
		#echo " ... reading file $line"
		$cdo showtimestamp $line
	done < list_of_files

#
#   the end
#


