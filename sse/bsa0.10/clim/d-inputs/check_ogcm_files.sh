#!/bin/bash
#
	today=$1
	ogcm=$2
	dh=$3

	echo
	echo " +++ Starting script to check GFS files +++"
	echo

        domain="bsa0.08"
        ls -1 hncoda_${domain}_${dh}/${ogcm}_${today}* >& list_of_files

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
		$cdo showtimestamp $line | sed -e 's/T/ /g' | awk '{print $1, $2, $4, $6, $8, $9, $10}'
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
                nlon=`ncdump -h $line | grep "lon = " | awk '{print $3}'`
		nlat=`ncdump -h $line | grep "lat = " | awk '{print $3}'`
		nvar=`ncdump -h $line | grep short | wc -l`
		if [ "$nvar" -eq  "0" ]; then nvar=`ncdump -h $line | grep float | wc -l`; fi
	        echo " ... file: $line has $nlon lons, $nlat lats, $nvar vars" 
        done < list_of_files

	echo
	echo " ... names of vars are: "
	echo

	file=`sed '1q;d' list_of_files`
	ncdump -h $file | grep short

	echo
        echo " ... the n. of files is $nfiles"
        echo

	echo
	echo " +++ End of Script +++"
	echo

#
#   the end
#


