#!/bin/bash
#
        ########### compute ensembles from ROMS output files

	roms_dir="$HOME/roms/cases/sse/bsa0.10/expts/gfs+glby_no_tide_20200101_366d_rad"
        roms_avg_file="$roms_dir/d-storage/20200101_366d/roms_avg_bsa0.10_01a_20200101_glby.nc"
        roms_his_file="$roms_dir/d-storage/20200101_366d/roms_his_bsa0.10_01a_20200101_glby.nc"

	outdir="$HOME/roms/cases/sse/bsa0.10/enkf-c/d-ensemble/static"


        echo 
        echo " ... Starting script to make static ensemble members for the year of 2020 ..."
        echo

	#cdo="cdo -s --no_warnings"


	n1=7
	nt=358
	dn=14

	vars="zeta,temp,salt,u,ubar,v,vbar"
	varss="zeta temp salt u ubar v vbar"


	ncks -v $vars $roms_avg_file romsfile.nc
	ncatted -h -O -a ,global,d,c,  romsfile.nc

	member=0


	for (( n=$n1; n <=$nt; n+=$dn )); do

		let m1=$n-7
		let m2=$n+7
		let member=$member+1

		M=`echo $member | awk '{printf "%3.3d", $1}'`

		echo; echo " ... day $n, ensemble member $M "; echo
	
		for var in $varss; do

			echo " ... VAR $var"; echo	

			echo " ... ... extract time range from day $m1 to day $m2"; echo
			ncks -d ocean_time,$m1,$m2 -v $var  romsfile.nc  tmp.nc

			echo " ... ... compute two-week average"; echo
			ncra tmp.nc two_weeks_avg.nc; rm tmp.nc


                	echo " ... ... extract one-day average"; echo
			ncks -d ocean_time,$n -v $var  romsfile.nc  one_day_avg.nc


                	echo " ... ... compute diff one-day avg - two-week avg"; echo
			ncdiff -O -v $var one_day_avg.nc two_weeks_avg.nc tmp.nc 
			rm two_weeks_avg.nc one_day_avg.nc

			echo " ... ... delete time dimension "; echo
			ncwa -O -a ocean_time tmp.nc tmp2.nc
			ncks -x -v ocean_time tmp2.nc mem${M}_${var}.nc
			rm tmp.nc tmp2.nc

		done

	done

	rm romsfile.nc

	echo
	echo " ... End of script ..."
	echo	

	
