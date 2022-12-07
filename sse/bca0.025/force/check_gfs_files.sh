#!/bin/bash
#
	today=$1

	echo
	echo " +++ Starting script to check GFS files +++"
	echo

	year=${today:0:4}
	let next=$year+1

	dh="03h"
        domain="glo0.50"
	dataset="anl4-hist"
        
	ls -1 d-inputs/gfsanl_historic_glo0.50_03h/gfs_${today}* >& list_of_files


	nfiles=`wc -l list_of_files`
	echo " ... the n. of files is $nfiles"
	echo

	cdo="cdo -s --no_warning"

	echo " ... check n. of time steps"
	echo 

	while read line; do
		#echo " ... reading file $line"
		ncdump -h $line | grep "time = "
	done < list_of_files

	echo " ... check files time stamp"
	echo 

	while read line; do
		#echo " ... reading file $line"
		$cdo showtimestamp $line | sed -e 's/T/ /g' | awk '{print $1, $2, $4, $6, $8, $10, $12, $14, $16, $18}'
	done < list_of_files
	echo
        echo " ... check files size"
        echo

        while read line; do
                #echo " ... reading file $line"
                ls -alh $line | sed -e 's/\//  /g' | awk '{print $10,$5}'
        done < list_of_files

        echo
        echo " ... check variables & variable dimensions"
        echo

        while read line; do
                #echo " ... reading file $line"
                nlon=`ncdump -h $line | grep "longitude = " | awk '{print $3}'`
		nlat=`ncdump -h $line | grep "latitude = " | awk '{print $3}'`
		nvar=`ncdump -h $line | grep float | wc -l`
	        echo " ... file: $line has $nlon lons, $nlat lats, $nvar vars" 
        done < list_of_files

	echo
	echo " ... names of vars are: "
	echo

	file=`sed '1q;d' list_of_files`
	ncdump -h $file | grep float 

	echo
        echo " ... the n. of files is $nfiles"
        echo

	echo
	echo " +++ End of Script +++"
	echo

#
#   the end
#


