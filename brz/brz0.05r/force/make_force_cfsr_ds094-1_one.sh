#!/bin/bash
#

	#### CFSR data directory is

	ddir="d-inputs/ds094.1_GLB_2015-2020_0.25x0.25"

	####

        echo
        echo " +++ Starting script to extract CFSR grib data to netcdf +++"
        echo

	var=$1
	year=$2

	#### pressure at mean sea level has a different approach
	####  it is dumped at analysis and 3 hour forecast

	#### all other vars will be dumped at 3 hour and 6 hour forecast

	if [ "$var" == "prmsl" ]; then

		echo
                echo " ... will create a file for variable $var for year $year"
                echo

                ls -1 $ddir/${var}.cdas1.${year}*.grb2 > list

                while read line; do

                        echo " ... reading file $line"; echo

                        fdate=`echo $line | sed -e 's/\./ /g' | awk '{print $(NF-1)}'`
                        output="${var}_${fdate}.nc"

                        wgrib2 $line | egrep "(anl|3 hour)" | \
                        wgrib2 -i $line -lola -167:201:0.25 15:129:0.25 tmp.grb grib; wait
                        wgrib2 tmp.grb -nc4 -netcdf $output; wait
                        rm tmp.grb

                done < list

		let next_year=$year+1
                next_date="${next_year}0101"
                next_file="$ddir/${var}.cdas1.${next_year}01.grb2"
                output="${var}_${year}13.nc"

		wgrib2 $next_file | egrep "($next_date)" | egrep "(anl|3 hour)" | \
                wgrib2 -i $next_file -lola -167:201:0.25 15:129:0.25 tmp.grb grib; wait
                wgrib2 tmp.grb -nc4 -netcdf tmp.nc; wait
                ncks -d time,0 tmp.nc $output; wait
                rm tmp.grb tmp.nc

		cdo mergetime ${var}_${year}*.nc cfsr_${var}_${year}.nc; wait
                rm ${var}_20*.nc


        elif [ "$var" == "q2m"    -o "$var" == "prate"  -o "$var" == "tmp2m"  -o "$var" == "wnd10m" \
	       "$var" == "dlwsfc" -o "$var" == "dswsfc" -o "$var" == "ulwsfc" -o "$var" == "uswsfc"]; then

		echo
		echo " ... will create a file for variable $var for year $year"
		echo 

		ls -1 $ddir/${var}.cdas1.${year}*.grb2 > list

		while read line; do

			echo " ... reading file $line"; echo

			fdate=`echo $line | sed -e 's/\./ /g' | awk '{print $(NF-1)}'`
			output="${var}_${fdate}.nc"

			wgrib2 $line | egrep "(3 hour|6 hour)" | \
			wgrib2 -i $line -lola -167:201:0.25 15:129:0.25 tmp.grb grib; wait
			wgrib2 tmp.grb -nc4 -netcdf $output; wait
			rm tmp.grb

		done < list

		let previous_year=$year-1
		previous_date="${previous_year}1231"
		previous_file="$ddir/${var}.cdas1.${previous_year}12.grb2"
		output="${var}_${year}00.nc"

		wgrib2 $previous_file | egrep "($previous_date)" | egrep "(3 hour|6 hour)" | \
		wgrib2 -i $previous_file -lola -167:201:0.25 15:129:0.25 tmp.grb grib; wait
		wgrib2 tmp.grb -nc4 -netcdf tmp.nc; wait
		ncks -d time,-1 tmp.nc $output; wait
		rm tmp.grb tmp.nc

		cdo mergetime ${var}_${year}*.nc cfsr_${var}_${year}.nc; wait
		rm ${var}_20*.nc

	else

		echo
		echo " ... var $var not found, exiting"
	        echo
	        exit

	fi

	echo
	echo " ... concatenate all files in one "
	echo

        #for var in q2m tmp2m prate prmsl wnd10m dlwsfc dswsfc ulwsfc uswsfc; do
	#	ncks -A cfsr_${var}_${year}.nc cfsr_${year}.nc
	#done

        echo
        echo " +++ End os Script +++"
        echo




# the end
