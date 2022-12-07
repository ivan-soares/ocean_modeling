#!/bin/bash
#
	ls -1 trunk/gfs_201905* trunk/gfs_20190601.nc >& list_of_files

	cdo="cdo -s --no_warning"

	while read line; do
		#echo " ... reading file $line"
		$cdo showtimestamp $line
	done < list_of_files

#
#   the end
#


