#!/bin/bash
#
	########### caompute avg of year 2020

	roms_avg_file="$HOME/roms/cases/sse/bsa0.10/expts/gfs+glby_no_tide_20200101_366d_rad/d-storage/20200101/roms_avg_bsa0.10_01a_20200101_glby.nc"
        roms_his_file="$HOME/roms/cases/sse/bsa0.10/expts/gfs+glby_no_tide_20200101_366d_rad/d-storage/20200101/roms_his_bsa0.10_01a_20200101_glby.nc"

	roms_avg="roms_avg_2020.nc"
	roms_anom="roms_anom_2020.nc"

	iopt=$1

	echo 
	echo " ... Starting script to make ensemble members  for the year of 2020 ..."
	echo

	if [ $iopt -eq 1 ]; then

		echo
		echo " ... running option $iopt : compute averages and anomalies"
		echo

		if [ -e $roms_avg ]; then rm $roms_avg ; fi
		if [ -e $roms_anom ]; then rm $roms_anom ; fi

		ncks -v u,ubar $roms_avg_file roms_avg_u.nc
		ncks -v v,vbar $roms_avg_file roms_avg_v.nc
		ncks -v temp,salt,zeta $roms_avg_file roms_avg_tsz.nc

		cdo timavg roms_avg_u.nc roms_avg_2020_u.nc ; wait
		cdo timavg roms_avg_v.nc roms_avg_2020_v.nc ; wait
		cdo timavg roms_avg_tsz.nc roms_avg_2020_tsz.nc ; wait

		cdo sub roms_avg_u.nc roms_avg_2020_u.nc roms_anom_u.nc; wait
		cdo sub roms_avg_v.nc roms_avg_2020_v.nc roms_anom_v.nc; wait
		cdo sub roms_avg_tsz.nc roms_avg_2020_tsz.nc roms_anom_tsz.nc; wait

        elif [ $iopt -eq 2 ]; then

		echo
		echo " ... running option $iopt : make emsemble members"
		echo

		nd=90
		dd=2
		n=1

		for ((i=1; i <= $nd; i+=$dd )); do

		     nnn=$(printf "%3.3d\n" $n)

		     member="mem${nnn}_temp.nc"
		     echo ; echo " ... doing ensemble member $member"; echo
		     ncks -v temp  -d ocean_time,$i,$i roms_anom_tsz.nc tmp.nc; wait
		     ncwa -O -a ocean_time tmp.nc $member; wait		
		     rm tmp.nc

		     member="mem${nnn}_salt.nc"
		     echo ; echo " ... doing ensemble member $member"; echo
		     ncks -v salt  -d ocean_time,$i,$i roms_anom_tsz.nc tmp.nc; wait
		     ncwa -O -a ocean_time tmp.nc $member; wait
		     rm tmp.nc

		     member="mem${nnn}_zeta.nc"
		     echo ; echo " ... doing ensemble member $member"; echo
		     ncks -v zeta  -d ocean_time,$i,$i roms_anom_tsz.nc tmp.nc; wait
		     ncwa -O -a ocean_time tmp.nc $member; wait
		     rm tmp.nc

		     member="mem${nnn}_u.nc"
		     echo ; echo " ... doing ensemble member $member"; echo
		     ncks -v u  -d ocean_time,$i,$i roms_anom_u.nc tmp.nc; wait
		     ncwa -O -a ocean_time tmp.nc $member; wait
		     rm tmp.nc

		     member="mem${nnn}_v.nc"
		     echo ; echo " ... doing ensemble member $member"; echo
		     ncks -v v  -d ocean_time,$i,$i roms_anom_v.nc tmp.nc; wait
		     ncwa -O -a ocean_time tmp.nc $member; wait
		     rm tmp.nc

                     member="mem${nnn}_ubar.nc"
                     echo ; echo " ... doing ensemble member $member"; echo
                     ncks -v ubar  -d ocean_time,$i,$i roms_anom_u.nc tmp.nc; wait
                     ncwa -O -a ocean_time tmp.nc $member; wait
                     rm tmp.nc

                     member="mem${nnn}_vbar.nc"
                     echo ; echo " ... doing ensemble member $member"; echo
                     ncks -v vbar  -d ocean_time,$i,$i roms_anom_v.nc tmp.nc; wait
                     ncwa -O -a ocean_time tmp.nc $member; wait
                     rm tmp.nc

		     let n=$n+1

		done

	fi

        echo 
        echo " ... END of script to make ensemble members  for the year of 2020 ..."
        echo

#
#   the end
#
