#!/bin/bash
#

	ddir="d-storage/atmos_era5"

	echo
	echo " +++ Starting code to fiz era5 var names and attributes +++"
	echo

	cp $ddir/*.nc .

	year=2014

	for var in humi lwrad pressure rain srad temp u v; do

		infile=${var}_era${year}.nc

		time_name=`ncdump -h $infile | 
			grep "time:time" | sed 's/:/ /g' |
			awk '{print $1}'`

		var_name=`ncdump -h $infile |
			grep "time, lat, lon" |
			sed 's/(/ /g' |
			awk '{print $2}'`

		ncrename -v ${time_name},time $infile
		ncrename -d ${time_name},time $infile

		ncatted -O -a time,time,o,c,"time" $infile
		ncatted -O -a field,time,o,c,"time, scalar, series" $infile

		ncatted -O -a time,${var_name},o,c,"time" $infile
		ncatted -O -a coordinates,${var_name},o,c,"lon lat" $infile

	done

	for var in humi lwrad pressure rain srad temp u v; do 
		ncks -h -A ${var}_era2014.nc force.nc
	done

	echo
	echo " +++ End of code +++"
	echo
